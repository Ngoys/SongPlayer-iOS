import Foundation
import Combine

class SongCellViewModel {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(song: Song) {
        self.song = song
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var titleText: String? {
        return song.name
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let song: Song
}
