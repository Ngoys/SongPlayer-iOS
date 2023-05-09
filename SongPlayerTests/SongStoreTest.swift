import XCTest
import Combine
@testable import SongPlayer

class SongStoreTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var store: SongStore!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupStore() {
        // Normally, I would use Cuckoo library to mock API return data
        // So that we would not call the real API,
        // Because if API change a song's value, some lines might test fail
        store = SongStore(apiClient: mockAPIClient, coreDataStore: mockCoreDataStore)
    }

    override func setUp() {
        super.setUp()
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------
    
    func testSongInit() {
        let songsWithoutLocalFilePath = [mockSongs[0], mockSongs[2]]
        songsWithoutLocalFilePath.forEach { song in
            XCTAssert(song.localFilePath == nil)
            XCTAssert(song.uiStateSubject.value.status == .canDownload)
        }
        
        let songsWithLocalFilePath = [mockSongs[1], mockSongs[3]]
        songsWithLocalFilePath.forEach { song in
            XCTAssert(song.localFilePath != nil)
            XCTAssert(song.uiStateSubject.value.status == .canPlay)
        }
    }
    
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
            XCTAssert(songs.filter{ self.mockSongs.contains($0) }.count == 4)
            XCTAssert(self.mockCoreDataStore.fetchAllSongs().count == songs.count)

            XCTAssert(songs.count > 2)
            XCTAssert(songs[1].localFilePath == mockLocalFilePath)
            XCTAssert(songs[1].uiStateSubject.value.status == .canPlay)

            expectation.fulfill()
        }).store(in: &cancellables)

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchSongsError() {
        apiBaseURL = URL(string: "https://www.google.com/")!
        mockAPIClient = SongPlayerAPIClient(apiBaseURL: apiBaseURL, httpClient: mockHTTPClient)
        
        setupStore()
        
        let expectation = expectation(description: "Wait for API call")

        store.fetchSongs().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                XCTFail("Should not execute this block clause")

            case .failure(let error):
                XCTAssert(error as! AppError == .notFound)
                expectation.fulfill()
            }
        }, receiveValue: { songs in
            XCTFail("Should not execute this block clause")
            expectation.fulfill()
        }).store(in: &cancellables)

        waitForExpectations(timeout: 5, handler: nil)
    }
}
