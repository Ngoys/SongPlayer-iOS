import Foundation
import Combine

class SongListViewModel: StatefulViewModel<[Song]> {

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
    func fetchAllSongDataModals() -> [Song] {
        return self.coreDataStore.fetchAllSongs()
    }
    override func load() -> AnyPublisher<[Song], Error> {
        print("SongListViewModel - fetchSongs()")
        return songStore.fetchSongs().map { songs in
            print("SongListViewModel - fetchSongs() - completed:\n\(songs)")

            let songs = self.coreDataStore.fetchAllSongs()

//            songs.map { song in
//                // If the song is downloaded previously and stored in core data,
//                // We change the status to .canPlay and update SongView's UI
//                if let songDataModal = songDataModals.first(where: { $0.id == song.id }),
//                   songDataModal.localFilePath != nil {
//                    var uiStateClone = song.state.value
//                    uiStateClone.status = .canPlay
//                    song.state.send(uiStateClone)
//                }
//                return song
//            }

            self.songsSubject.send(songs)
            return self.songsSubject.value
        }.eraseToAnyPublisher()
    }

    func download(id: String) {
        guard let song = songsSubject.value.first(where: { $0.id == id }) else { return }

        let downloadItem = downloadStore.download(contentIdentifier: song.downloadContentIdentifier, downloadURL: song.downloadURL, downloadFileFormat: song.downloadFileFormat)
        handleDownloadItemStatusChange(downloadItem: downloadItem)
    }

    private func handleDownloadItemStatusChange(downloadItem: DownloadItem) {
        guard let song = self.songsSubject.value.first(where: { $0.id == downloadItem.contentIdentifier }) else { return }

        downloadItem.statusDidChange
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] status in
                guard let self = self else { return }

                var uiStateClone = song.uiState.value

                switch status {
                case .downloaded(let localFilePath):
                    self.coreDataStore.updateSongLocalFilePath(id: song.id, localFilePath: localFilePath)
                    song.localFilePath = localFilePath
                    uiStateClone.status = .canPlay

                case .downloading(let progress):
                    uiStateClone.status = .isDownloading(progress: progress)

                case .error(_):
                    uiStateClone.status = .canDownload

                case .queued:
                    uiStateClone.status = .isDownloading(progress: 0)
                }

                song.uiState.send(uiStateClone)
            }).store(in: &cancellables)
    }

    func play(id: String) {
        guard let song = songsSubject.value.first(where: { $0.id == id }),
              let localFilePath = self.coreDataStore.fetchSongLocalFilePath(id: id),
              let localPathURL = URL(string: localFilePath) else { return }

        print("hello world")
    }

    func pause() {
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let songsSubject = CurrentValueSubject<[Song], Never>([])

    private let songStore: SongStore

    private let downloadStore: DownloadStore

    private let coreDataStore: CoreDataStore
}
