import Foundation
import Combine

class SongPresentationModel: Hashable {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(song: Song) {
        self.song = song
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    let song: Song
    let state = CurrentValueSubject<SongPresentationState, Never>(SongPresentationState())

    //----------------------------------------
    // MARK: - Hashable protocols
    //----------------------------------------

    func hash(into hasher: inout Hasher) {
        hasher.combine(song.id)
    }

    static func == (lhs: SongPresentationModel, rhs: SongPresentationModel) -> Bool {
        lhs.song.id == rhs.song.id
    }
}
