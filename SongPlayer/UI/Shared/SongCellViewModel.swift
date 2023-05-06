import Foundation
import UIKit

class SongCellViewModel {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------
    
    init(song: Song) {
        self.song = song
    }
    
    //----------------------------------------
    // MARK: - Presentation
    //----------------------------------------

    var titleText: String? {
        return self.song.name
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private let song: Song
}
