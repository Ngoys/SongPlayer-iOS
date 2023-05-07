import Foundation
import MediaPlayer

class RemoteCommandCenterManager: NSObject {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(audioPlayer: AudioPlayer) {
        self.audioPlayer = audioPlayer

        super.init()

        // More action to be implemented
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
            audioPlayer.play(seek: nil)
        }

        return .success
    }

    func updateRemoteCommandCenterCommandForCurrentItem() {
        // To be implemented
        let remoteCommandCenter = MPRemoteCommandCenter.shared()
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private var audioPlayer: AudioPlayer?
}
