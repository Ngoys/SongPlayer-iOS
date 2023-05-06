import Foundation
import Combine

class SongListViewModel: StatefulViewModel<[SongPresentationModel]> {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(songStore: SongStore) {
        self.songStore = songStore
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    override func load() -> AnyPublisher<[SongPresentationModel], Error> {
        print("SongListViewModel - fetchSongs()")
        return songStore.fetchSongs() .map { songs in
            print("SongListViewModel - fetchSongs() - completed:\n\(songs)")
            let songPresentationModels = songs.map { song in
                return SongPresentationModel(song: song)
            }

            self.songPresentationModelsSubject.send(songPresentationModels)
            return self.songPresentationModelsSubject.value
        }.eraseToAnyPublisher()
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let songPresentationModelsSubject = CurrentValueSubject<[SongPresentationModel], Never>([])

    private let songStore: SongStore
}
