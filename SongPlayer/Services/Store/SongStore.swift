import Foundation
import Combine

class SongStore: BaseStore {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(apiClient: APIClient, coreDataStore: CoreDataStore) {
        self.apiClient = apiClient
        self.coreDataStore = coreDataStore
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func fetchSongs() -> AnyPublisher<[Song], Error> {
        let endPoint = "Lenhador/a0cf9ef19cd816332435316a2369bc00/raw/a1338834fc60f7513402a569af09ffa302a26b63/Songs.json"

        let publisher = apiClient.apiRequest(.get, endPoint)
            .tryMap { apiResponse -> [Song] in
                let decodedModel = try self.decoder.decode(SongPlayerAPIJSON<[Song]>.self, from: apiResponse.data)
                return decodedModel.data
            }
            .map { [weak self] fetchedSongs in
                guard let self = self else { return fetchedSongs }

                // Save fetched songs to Core Data
                fetchedSongs.forEach { song in
                    self.coreDataStore.createOrUpdateSong(song: song)
                }

                // If the song is downloaded previously and stored in Core Data,
                // We will update the localFilePath,
                // and change the status to .canPlay to update theSongView's UI
                let previouslyDownloadedSongs = self.coreDataStore.fetchAllSongs().filter{ fetchedSongs.contains($0) && $0.localFilePath != nil }
                previouslyDownloadedSongs.forEach { song in
                    if let fetchedSong = fetchedSongs.first(where: { $0 == song }) {
                        fetchedSong.localFilePath = song.localFilePath
                    }
                }

                return fetchedSongs
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

        return publisher
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let apiClient: APIClient

    private let coreDataStore: CoreDataStore
}
