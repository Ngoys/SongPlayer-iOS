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
        guard let player = avPlayer else {
            return false
        }

        let isPlaying = player.currentItem != nil && player.timeControlStatus != .paused
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
            // Do nothing if setting the current item again.
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

    var playbackRate: Float = 1.0 {
        didSet {
            if oldValue != self.playbackRate {
                self.avPlayer?.rate = self.playbackRate

                if currentAudioContent != nil {
                    nowPlayingInfoCenterManager.updateNowPlayingInfo()
                    audioPlayerStateDidChangeSubject.send(self)
                }
            }
        }
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func play(seek: Double?) {
        // To be implemented, for seek

        assert(Thread.isMainThread)

        guard let currentAudioContent = self.currentAudioContent else {
            return
        }

        if self.avPlayer?.currentItem != nil && self.avPlayer?.timeControlStatus == .paused {
            self.avPlayer?.rate = playbackRate
        } else {
            guard let mediaURL = currentAudioContent.audioContentURL else {
                print("BasicAudioPlayer - could not get audioContentURL for the currentAudioContent \(currentAudioContent.audioContentURL)")
                return
            }

            if self.avPlayer == nil {
                let avAsset = AVURLAsset(url: mediaURL)
                let avPlayerItem = AVPlayerItem(asset: avAsset)
                let avPlayer = AVPlayer(playerItem: avPlayerItem)

                observations.append(avPlayer.observe(\AVPlayer.timeControlStatus) { [weak self] player, change in
                    guard let self = self else { return }

                    switch player.timeControlStatus {
                    case .paused:
                        print("BasicAudioPlayer - timeControlStatus => paused")

                    case .playing:
                        print("BasicAudioPlayer - timeControlStatus => playing")

                    case .waitingToPlayAtSpecifiedRate:
                        print("BasicAudioPlayer - timeControlStatus => waitingToPlayAtSpecifiedRate")

                    default:
                        print("BasicAudioPlayer - timeControlStatus => unknown")
                    }

                    self.audioPlayerStateDidChangeSubject.send(self)
                })

                observations.append(avPlayer.observe(\AVPlayer.reasonForWaitingToPlay) { [weak self] player, change in
                    guard let self = self else { return }

                    switch player.reasonForWaitingToPlay {
                    case AVPlayer.WaitingReason.evaluatingBufferingRate:
                        print("BasicAudioPlayer - AVPlayer.reasonForWaitingToPlay => evaluatingBufferingRate")

                    case AVPlayer.WaitingReason.noItemToPlay:
                        print("BasicAudioPlayer - AVPlayer.reasonForWaitingToPlay => noItemToPlay")

                    case AVPlayer.WaitingReason.toMinimizeStalls:
                        print("BasicAudioPlayer - AVPlayer.reasonForWaitingToPlay => toMinimizeStalls")

                    default:
                        print("BasicAudioPlayer - AVPlayer.reasonForWaitingToPlay => unknown")
                    }
                })

                observations.append(avPlayerItem.observe(\AVPlayerItem.status) { [weak self] playerItem, change in
                    guard let self = self else { return }

                    switch playerItem.status {
                    case .unknown:
                        print("BasicAudioPlayer - AVPlayerItem.status => unknown")

                    case .readyToPlay:
                        print("BasicAudioPlayer - AVPlayerItem.status => readyToPlay")

                    case .failed:
                        print("BasicAudioPlayer - AVPlayerItem.status => failed")
                        self.pause(forceDispose: true)

                    default:
                        print("BasicAudioPlayer - AVPlayer.status => unknown")
                    }
                })

                self.avPlayer = avPlayer
            }

            self.avPlayer?.rate = playbackRate
        }

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
            // When disposing, we don't get a signal from the player about playback state changes.
            audioPlayerStateDidChangeSubject.send(self)
        }

        remoteCommandCenterManager.updateRemoteCommandCenterCommandForCurrentItem()
        nowPlayingInfoCenterManager.updateNowPlayingInfo()
    }

    func reset() {
        pause(forceDispose: false)
        disposeAudioPlayer()
        _currentAudioContent = nil
        playbackRate = 1.0
    }

    private func disposeAudioPlayer() {
        observations.removeAll()
        self.avPlayer?.replaceCurrentItem(with: nil)
        self.avPlayer = nil
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
