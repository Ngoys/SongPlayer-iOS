import Foundation
import Combine

class SongListViewModel: StatefulViewModel<[SongPresentationModel]> {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(songStore: SongStore, downloadStore: DownloadStore) {
        self.songStore = songStore
        self.downloadStore = downloadStore
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
                case .downloaded(_):
                    //TODO save song in coredata
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
        guard let songPresentationModel = songPresentationModelsSubject.value.first(where: { $0.song.id == id }) else { return }
    }

    func pause() {
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let songPresentationModelsSubject = CurrentValueSubject<[SongPresentationModel], Never>([])

    private let songStore: SongStore

    private let downloadStore: DownloadStore
}
