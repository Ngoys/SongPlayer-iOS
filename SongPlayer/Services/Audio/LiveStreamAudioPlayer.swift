import Foundation
import MediaPlayer
import Combine

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
        // To be implemented
        return false
    }

    var isLoading: Bool {
        // To be implemented
        return false
    }

    var currentAudioContent: AudioContent? {
        get {
            // To be implemented
            return nil
        }
        set {
            // To be implemented
        }
    }

    var playbackRate: Float = 1.0

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func play(seek: Double?) {
        // To be implemented
    }

    func pause(forceDispose: Bool) {
        // To be implemented
    }

    func reset() {
        // To be implemented
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let remoteCommandCenterManager: RemoteCommandCenterManager

    private let nowPlayingInfoCenterManager: NowPlayingInfoCenterManager

    private var cancellables = Set<AnyCancellable>()
}
