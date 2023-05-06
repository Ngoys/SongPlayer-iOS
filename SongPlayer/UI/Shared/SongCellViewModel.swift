import Foundation
import Combine

class SongCellViewModel {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(songPresentationModel: SongPresentationModel) {
        self.songPresentationModel = songPresentationModel
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var titleText: String? {
        return songPresentationModel.song.name
    }

    var statePublisher: AnyPublisher<SongPresentationState, Never> {
        return songPresentationModel.state.eraseToAnyPublisher()
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let songPresentationModel: SongPresentationModel
}
