import Foundation
import MediaPlayer

// Future expansion
class RemoteCommandCenterManager: NSObject {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(audioPlayer: AudioPlayer) {
        self.audioPlayer = audioPlayer

        super.init()

        let center = MPRemoteCommandCenter.shared()
        center.togglePlayPauseCommand.addTarget(self, action: #selector(handleTogglePlayPauseRemoteCommand(_:)))
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    @objc private func handleTogglePlayPauseRemoteCommand(_ event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        guard let audioPlayer = audioPlayer else {
            return .commandFailed
        }

        if audioPlayer.isPlaying {
            audioPlayer.pause(forceDispose: false)
        } else {
            audioPlayer.play(seekTime: nil)
        }

        return .success
    }

    func updateRemoteCommandCenterCommandForCurrentItem() {
        let remoteCommandCenter = MPRemoteCommandCenter.shared()
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private var audioPlayer: AudioPlayer?
}
