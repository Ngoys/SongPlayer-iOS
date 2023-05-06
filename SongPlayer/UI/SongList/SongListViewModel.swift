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
        return songStore.fetchSongs().map { songs in
            print("SongListViewModel - fetchSongs() - completed:\n\(songs)")
            let songPresentationModels = songs.map { song in
                return SongPresentationModel(song: song)
            }

            self.songPresentationModelsSubject.send(songPresentationModels)
            return self.songPresentationModelsSubject.value
        }.eraseToAnyPublisher()
    }

    func download(id: String) {
        guard let songPresentationModel = songPresentationModelsSubject.value.first(where: { $0.song.id == id }) else { return }
        var stateClone = songPresentationModel.state.value
        stateClone.status = .canPlay
        songPresentationModel.state.send(stateClone)
    }

    func play(id: String) {
        guard let songPresentationModel = songPresentationModelsSubject.value.first(where: { $0.song.id == id }) else { return }

        for i in stride(from: 0.1, through: 1.0, by: 0.1) {
            var stateClone = songPresentationModel.state.value
            stateClone.status = .isDownloading(progress: i)
            songPresentationModel.state.send(stateClone)
        }
    }

    func pause() {
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let songPresentationModelsSubject = CurrentValueSubject<[SongPresentationModel], Never>([])

    private let songStore: SongStore
}
