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

        super.init()

        //----------------------------------------
        // MARK: - Start observing data
        //----------------------------------------

        audioPlayerService.audioPlayerStateDidChangePublisher
            .sink { [weak self] audioPlayer in
                guard let self = self,
                      let song = self.songsSubject.value.first(where: { $0.id == audioPlayer?.currentAudioContent?.audioContentIdentifier }) else { return }

                var uiStateClone = song.uiState.value

                if audioPlayer == nil {
                    uiStateClone.status = .canPause
                } else if audioPlayer?.isLoading == true {
                    // We can set the uiStateClone attribute, then the SongView will update automatically
                    // For example, set uiStateClone.status = .isLoading to show a activity indicator in the SongView UI
                } else if audioPlayer?.isPlaying == true {
                    uiStateClone.status = .canPause
                } else if audioPlayer?.isPlaying == false {
                    uiStateClone.status = .canPlay
                }

                song.uiState.send(uiStateClone)
            }.store(in: &cancellables)

        downloadStore.downloadingItemsPublisher.zip(self.songsSubject)
            .sink { [weak self] (downloadingItems, songs) in
                guard let self = self else { return }

                // If there is existing download triggered by other View Controller page,
                // Everytime when new value being accepted in songsSubject or there is a new downloading items,
                // We need to check and update the uiState.status according to the downloadItem.status
                let downloadingSongs = downloadingItems.filter { downloadItem in
                    return songs.contains(where: { $0.id == downloadItem.contentIdentifier })
                }
                downloadingSongs.forEach { downloadItem in
                    self.handleDownloadItemStatusChange(downloadItem: downloadItem)
                }
            }.store(in: &cancellables)
    }
    
    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    override func load() -> AnyPublisher<[Song], Error> {
        return songStore.fetchSongs().map { songs in
            print("SongListViewModel - fetchSongs() - completed: \(songs)")
            self.songsSubject.send(songs)
            return self.songsSubject.value
        }.eraseToAnyPublisher()
    }

    func fetchAllCoreDataSongs() -> [Song] {
        let songs = self.coreDataStore.fetchAllSongs()
        self.songsSubject.send(songs)
        return self.songsSubject.value
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

                case .error(let downloadError):
                    uiStateClone.status = .canDownload
                    self.promptUIAlertController.send(downloadError.errorAlertDialog)

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
        audioPlayerService.pause()
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
