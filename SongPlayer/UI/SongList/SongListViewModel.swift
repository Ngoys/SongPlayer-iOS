import Foundation
import Combine

class SongListViewModel: StatefulViewModel<[Song]> {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(songStore: SongStore, downloadStore: DownloadStore, coreDataStore: CoreDataStore, audioPlayerService: AudioPlayerService) {
        self.songStore = songStore
        self.downloadStore = downloadStore
        self.coreDataStore = coreDataStore
        self.audioPlayerService = audioPlayerService
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    override func load() -> AnyPublisher<[Song], Error> {
        return songStore.fetchSongs().map { songs in
            print("SongListViewModel - fetchSongs() - completed:\n\(songs)")
            self.songsSubject.send(songs)
            return self.songsSubject.value
        }.eraseToAnyPublisher()
    }

    func fetchAllCoreDataSongs() -> [Song] {
        return self.coreDataStore.fetchAllSongs()
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
        guard let song = self.songsSubject.value.first(where: { $0.id == id }) else { return }
        audioPlayerService.currentAudioContent = song
        audioPlayerService.play(seek: 0)
    }

    func pause() {
        audioPlayerService.pause(forceDispose: false)
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let songsSubject = CurrentValueSubject<[Song], Never>([])

    private let songStore: SongStore

    private let downloadStore: DownloadStore

    private let coreDataStore: CoreDataStore

    private let audioPlayerService: AudioPlayerService
}
