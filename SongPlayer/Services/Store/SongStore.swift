import Foundation
import Combine

class SongStore: BaseStore {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(apiClient: APIClient) {
        self.apiClient = apiClient
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
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()

        return publisher
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let apiClient: APIClient
}
