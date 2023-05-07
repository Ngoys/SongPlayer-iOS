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

    var statePublisher: AnyPublisher<SongUIState, Never> {
        return song.uiState.eraseToAnyPublisher()
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let song: Song
}
