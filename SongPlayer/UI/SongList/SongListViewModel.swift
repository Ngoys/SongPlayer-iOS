import Foundation
import Combine

class SongListViewModel: StatefulViewModel<[SongPresentationModel]> {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(songStore: SongStore, downloadStore: DownloadStore, coreDataStore: CoreDataStore) {
        self.songStore = songStore
        self.downloadStore = downloadStore
        self.coreDataStore = coreDataStore
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------
    func fetchAllSongDataModals() -> [SongPresentationModel] {
        return self.coreDataStore.fetchAllSongDataModals().map { songDataModal in
            let songPresentationModel = SongPresentationModel(song: songDataModal.toSong())
            if songDataModal.localFilePath != nil {
                var stateClone = songPresentationModel.state.value
                stateClone.status = .canPlay
                songPresentationModel.state.send(stateClone)
            }
            return songPresentationModel
        }
    }
    override func load() -> AnyPublisher<[SongPresentationModel], Error> {
        print("SongListViewModel - fetchSongs()")
        return songStore.fetchSongs().map { songs in
            print("SongListViewModel - fetchSongs() - completed:\n\(songs)")

            let songDataModals = self.coreDataStore.fetchAllSongDataModals()

            let songPresentationModels = songs.map { song in
                let songPresentationModel = SongPresentationModel(song: song)

                // If the song is downloaded previously and stored in core data,
                // We change the status to .canPlay and update SongView's UI
                if let songDataModal = songDataModals.first(where: { $0.id == song.id }),
                   songDataModal.localFilePath != nil {
                    var stateClone = songPresentationModel.state.value
                    stateClone.status = .canPlay
                    songPresentationModel.state.send(stateClone)
                }
                return songPresentationModel
            }

            self.songPresentationModelsSubject.send(songPresentationModels)
            return self.songPresentationModelsSubject.value
        }.eraseToAnyPublisher()
    }

    func download(id: String) {
        guard let songPresentationModel = songPresentationModelsSubject.value.first(where: { $0.song.id == id }) else { return }

        let downloadItem = downloadStore.download(contentIdentifier: songPresentationModel.song.downloadContentIdentifier, downloadURL: songPresentationModel.song.downloadURL, downloadFileFormat: songPresentationModel.song.downloadFileFormat)
        handleDownloadItemStatusChange(downloadItem: downloadItem)
    }

    private func handleDownloadItemStatusChange(downloadItem: DownloadItem) {
        guard let songPresentationModel = self.songPresentationModelsSubject.value.first(where: { $0.song.id == downloadItem.contentIdentifier }) else { return }

        downloadItem.statusDidChange
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] status in
                guard let self = self else { return }

                var stateClone = songPresentationModel.state.value

                switch status {
                case .downloaded(let localFilePath):
                    self.coreDataStore.updateSongLocalFilePath(id: songPresentationModel.song.id, localFilePath: localFilePath)

                    stateClone.status = .canPlay

                case .downloading(let progress):
                    stateClone.status = .isDownloading(progress: progress)

                case .error(_):
                    stateClone.status = .canDownload

                case .queued:
                    stateClone.status = .isDownloading(progress: 0)
                }

                songPresentationModel.state.send(stateClone)
            }).store(in: &cancellables)
    }

    func play(id: String) {
        guard let songPresentationModel = songPresentationModelsSubject.value.first(where: { $0.song.id == id }),
              let localFilePath = self.coreDataStore.fetchSongLocalFilePath(id: id),
              let localPathURL = URL(string: localFilePath) else { return }

        print("hello world")
    }

    func pause() {
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let songPresentationModelsSubject = CurrentValueSubject<[SongPresentationModel], Never>([])

    private let songStore: SongStore

    private let downloadStore: DownloadStore

    private let coreDataStore: CoreDataStore
}
