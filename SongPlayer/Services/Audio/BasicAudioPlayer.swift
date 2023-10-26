import Foundation
import MediaPlayer
import Combine

class BasicAudioPlayer: NSObject, AudioPlayer {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(remoteCommandCenterManager: RemoteCommandCenterManager,
         nowPlayingInfoCenterManager: NowPlayingInfoCenterManager) {
        self.remoteCommandCenterManager = remoteCommandCenterManager
        self.nowPlayingInfoCenterManager = nowPlayingInfoCenterManager
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    private let audioPlayerStateDidChangeSubject = CurrentValueSubject<AudioPlayer?, Never>(nil)
    var audioPlayerStateDidChangePublisher: AnyPublisher<AudioPlayer?, Never> {
        return audioPlayerStateDidChangeSubject.eraseToAnyPublisher()
    }

    var isPlaying: Bool {
        assert(Thread.isMainThread)
        guard let avPlayer = avPlayer else {
            return false
        }

        let isPlaying = avPlayer.currentItem != nil && avPlayer.timeControlStatus != .paused
        return isPlaying
    }

    var isLoading: Bool {
        assert(Thread.isMainThread)
        guard let avPlayer = avPlayer else {
            return false
        }

        let isLoading = avPlayer.currentItem != nil && avPlayer.timeControlStatus == .waitingToPlayAtSpecifiedRate
        return isLoading
    }

    var currentAudioContent: AudioContent? {
        get {
            return _currentAudioContent
        }

        set {
            // Do nothing if it is the same _currentAudioContent.
            if _currentAudioContent === newValue {
                return
            }

            reset()
            _currentAudioContent = newValue

            if _currentAudioContent != nil {
                UIApplication.shared.beginReceivingRemoteControlEvents()
                remoteCommandCenterManager.updateRemoteCommandCenterCommandForCurrentItem()
                nowPlayingInfoCenterManager.updateNowPlayingInfo()

                self.audioPlayerStateDidChangeSubject.send(self)
            } else {
                UIApplication.shared.endReceivingRemoteControlEvents()
            }
        }
    }

    var currentTime: TimeInterval {
        get {
            guard let player = avPlayer, let playerItem = player.currentItem else {
                return 0.0
            }

            if playerItem.currentTime().isNumeric {
                return playerItem.currentTime().seconds
            } else {
                return 0.0
            }
        }

        set {
            assert(Thread.isMainThread)

            avPlayer?.seek(to: CMTime(seconds: newValue, preferredTimescale: 1)) { success in
                if success {
                    self.nowPlayingInfoCenterManager.updateNowPlayingInfo()
                    self.audioPlayerStateDidChangeSubject.send(self)
                }
            }
        }
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func play(seekTime: Double?) {
        assert(Thread.isMainThread)

        guard let currentAudioContent = self.currentAudioContent else {
            return
        }

        if self.avPlayer?.currentItem != nil && self.avPlayer?.timeControlStatus == .paused {
            self.avPlayer?.play()
        } else {
            guard let mediaURL = currentAudioContent.audioContentURL else {
                print("BasicAudioPlayer - could not get audioContentURL for the currentAudioContent \(currentAudioContent.audioContentURL)")
                return
            }

            print("BasicAudioPlayer - play - URL: \(String(describing: currentAudioContent.audioContentURL))")
            
            if self.avPlayer == nil {
                let avAsset = AVURLAsset(url: mediaURL)
                let avPlayerItem = AVPlayerItem(asset: avAsset)
                let avPlayer = AVPlayer(playerItem: avPlayerItem)

                NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)

                observations.append(avPlayer.observe(\AVPlayer.timeControlStatus) { [weak self] player, change in
                    guard let self = self else { return }

                    switch player.timeControlStatus {
                    case .paused:
                        print("BasicAudioPlayer - timeControlStatus - paused")


                    case .playing:
                        print("BasicAudioPlayer - timeControlStatus - playing")

                    case .waitingToPlayAtSpecifiedRate:
                        print("BasicAudioPlayer - timeControlStatus - waitingToPlayAtSpecifiedRate")

                    default:
                        print("BasicAudioPlayer - timeControlStatus - unknown")
                    }

                    self.audioPlayerStateDidChangeSubject.send(self)
                })

                observations.append(avPlayerItem.observe(\AVPlayerItem.status) { [weak self] playerItem, change in
                    guard let self = self else { return }

                    switch playerItem.status {
                    case .unknown:
                        print("BasicAudioPlayer - AVPlayerItem.status - unknown")

                    case .readyToPlay:
                        print("BasicAudioPlayer - AVPlayerItem.status - readyToPlay")

                    case .failed:
                        print("BasicAudioPlayer - AVPlayerItem.status - failed")
                        self.pause(forceDispose: true)

                    default:
                        print("BasicAudioPlayer - AVPlayerItem.status - unknown")
                    }
                })
                self.avPlayer = avPlayer

                if let seekTime = seekTime {
                    currentTime = seekTime
                }
            }
            self.avPlayer?.play()
        }
        
        self.audioPlayerStateDidChangeSubject.send(self)
        
        remoteCommandCenterManager.updateRemoteCommandCenterCommandForCurrentItem()
        nowPlayingInfoCenterManager.updateNowPlayingInfo()
    }

    func pause(forceDispose: Bool) {
        assert(Thread.isMainThread)

        guard let currentAudioContent = self.currentAudioContent else {
            return
        }

        if currentAudioContent.audioContentType == .audioClip && forceDispose == false {
            self.avPlayer?.pause()
        } else {
            self.disposeAudioPlayer()
        }
        audioPlayerStateDidChangeSubject.send(self)

        remoteCommandCenterManager.updateRemoteCommandCenterCommandForCurrentItem()
        nowPlayingInfoCenterManager.updateNowPlayingInfo()
    }

    func reset() {
        pause(forceDispose: false)
        disposeAudioPlayer()
        _currentAudioContent = nil
    }

    private func disposeAudioPlayer() {
        observations.removeAll()
        self.avPlayer?.replaceCurrentItem(with: nil)
        self.avPlayer = nil
    }

    @objc private func playerDidFinishPlaying(notification: NSNotification) {
        print("BasicAudioPlayer - playerDidFinishPlaying - Reset avPlayer.seek to the start of the audio")
        currentTime = 0
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private var _currentAudioContent: AudioContent?

    private var avPlayer: AVPlayer?

    private let remoteCommandCenterManager: RemoteCommandCenterManager

    private let nowPlayingInfoCenterManager: NowPlayingInfoCenterManager

    private var observations: [NSKeyValueObservation] = []

    private var cancellables = Set<AnyCancellable>()
}
