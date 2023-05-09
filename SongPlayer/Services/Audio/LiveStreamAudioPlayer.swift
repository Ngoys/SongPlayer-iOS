import Foundation
import MediaPlayer
import Combine

// Future expansion
// We can integrate with any livestream radio player here in the class
// Like https://github.com/tritondigital/ios-sdk
class LiveStreamAudioPlayer: NSObject, AudioPlayer {

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
        return false
    }

    var isLoading: Bool {
        return false
    }

    var currentAudioContent: AudioContent? {
        get {
            return nil
        }
        set {
        }
    }

    var currentTime: TimeInterval {
        get {
            return 0
        }

        set {
        }
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func play(seekTime: Double?) {
    }

    func pause(forceDispose: Bool) {
    }

    func reset() {
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let remoteCommandCenterManager: RemoteCommandCenterManager

    private let nowPlayingInfoCenterManager: NowPlayingInfoCenterManager

    private var cancellables = Set<AnyCancellable>()
}
