import Foundation
import UIKit
import MediaPlayer

class NowPlayingInfoCenterManager {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(audioPlayer: AudioPlayer) {
        self.audioPlayer = audioPlayer
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func updateNowPlayingInfo() {
        // More info to be implemented
        var info: [String: Any] = [:]

        info[MPNowPlayingInfoPropertyMediaType] = MPNowPlayingInfoMediaType.audio.rawValue
        info[MPNowPlayingInfoPropertyIsLiveStream] = audioPlayer?.currentAudioContent?.audioContentType == .livestream
        info[MPMediaItemPropertyTitle] = audioPlayer?.currentAudioContent?.audioContentTitle ?? "live_radio".localized

        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
    }
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private var audioPlayer: AudioPlayer?

    private var nowPlayingInfoArtworkImage: UIImage?
}
