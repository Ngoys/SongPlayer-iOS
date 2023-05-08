import XCTest
import Combine
@testable import SongPlayer

class SongStoreTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var store: SongStore!

    var mockCoreDataStore: CoreDataStore!

    let songsJSON = """
    [
        {
          "id": "0",
          "name": "Song 1",
          "audioURL": "https://drive.google.com/uc?export=download&id=16-NMvJH4aJSgDpM66RizWe2qjHOP6n8f"
        },
        {
          "id": "1",
          "name": "Song 2",
          "audioURL": "https://drive.google.com/uc?export=download&id=1N3EW3CeY1v1L1bM4CtO5Fux1CYm5ZTLe"
        },
        {
          "id": "2",
          "name": "Song 3",
          "audioURL": "https://drive.google.com/uc?export=download&id=1vGk9m-A5JZZCgc23imDOfVfIPFOLVQcj"
        }
    ]
    """

    var mockSongs: [Song]!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupStore() {
        // Would normally use Cuckoo library to mock
        mockCoreDataStore = CoreDataStore(coreDataStack: mockCoreDataStack)
        mockCoreDataStore.deleteAllSongs()

        store = SongStore(apiClient: mockAPIClient, coreDataStore: mockCoreDataStore)

        let jsonData = songsJSON.data(using: .utf8)!
        mockSongs = try! JSONDecoder().decode([Song].self, from: jsonData)
    }

    override func setUp() {
        super.setUp()
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------

    func testFetchSongsSuccess() {
        setupStore()

        let mockLocalFilePath =  "\(FileManager.default.downloadDirectoryPathURL!.absoluteString)/\(mockSongs[1].id).mp3"
        mockCoreDataStore.createOrUpdateSong(song: Song(id: mockSongs[1].id, name: mockSongs[1].name, audioURL: mockSongs[1].audioURL, localFilePath: mockLocalFilePath))

        let expectation = expectation(description: "Wait for API call")

        store.fetchSongs().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break

            case .failure(_):
                XCTFail("Should not execute this block clause")
                expectation.fulfill()
            }
        }, receiveValue: { songs in
            XCTAssert(songs.filter{ self.mockSongs.contains($0) }.count == 3)
            XCTAssert(self.mockCoreDataStore.fetchAllSongs().count == songs.count)

            XCTAssert(songs.count > 2)
            XCTAssert(songs[1].localFilePath == mockLocalFilePath)
            XCTAssert(songs[1].uiStateSubject.value.status == .canPlay)

            expectation.fulfill()
        }).store(in: &cancellables)

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchSongsError() {
        //LALA
    }
}
