import XCTest
import Combine
@testable import SongPlayer

class SongListViewModelTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var viewModel: SongListViewModel!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupViewModel() {
        // Normally, I would use Cuckoo library to mock API return data
        // So that we would not call the real API,
        // Because if API change a song's value, some lines might test fail
        viewModel = SongListViewModel(songStore: SongStore(apiClient: mockAPIClient, coreDataStore: mockCoreDataStore), downloadStore: DownloadStore(), coreDataStore: mockCoreDataStore, audioPlayerService: AudioPlayerService())
    }

    override func setUp() {
        super.setUp()
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------
    
    func testFetchAllCoreDataSongs() {
        setupViewModel()
        
        let firstSong = mockSongs[0]
        let secondSong = mockSongs[1]
        mockCoreDataStore.createOrUpdateSong(song: firstSong)
        mockCoreDataStore.createOrUpdateSong(song: secondSong)
        
        let offlineSongs = viewModel.fetchAllCoreDataSongs()
        XCTAssert(offlineSongs.count == 2)
    }
    
    func testDownloadWithid() {
        let expectation = expectation(description: "Wait for viewModel.load() sink")
        
        var song = mockSongs[2]
        XCTAssert(song.localFilePath == nil)
        
        viewModel = SongListViewModel(songStore: SongStore(apiClient: mockAPIClient, coreDataStore: mockCoreDataStore), downloadStore: DownloadStore(), coreDataStore: mockCoreDataStore, audioPlayerService: AudioPlayerService())
        viewModel.load().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
                
            case .failure(_):
                XCTFail("Should not execute this block clause")
                expectation.fulfill()
            }
        }, receiveValue: { songs in
            if let songReference = songs.first(where: { $0 == song }) {
                song = songReference
            }
            expectation.fulfill()
        }).store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssert(song.uiStateSubject.value.status == .canDownload)
        viewModel.download(id: song.downloadContentIdentifier)
        XCTAssert(song.uiStateSubject.value.status == .isDownloading(progress: 0))
    }
    
    func testPlayWithid() {
        let expectation = expectation(description: "Wait for viewModel.load() sink")
        let mockAudioPlayerService = AudioPlayerService()
        
        let song = mockSongs[1]
        XCTAssert(song.localFilePath != nil)
        
        mockCoreDataStore.createOrUpdateSong(song: song)
        
        viewModel = SongListViewModel(songStore: SongStore(apiClient: mockAPIClient, coreDataStore: mockCoreDataStore), downloadStore: DownloadStore(), coreDataStore: mockCoreDataStore, audioPlayerService: mockAudioPlayerService)
        viewModel.load().sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break
                
            case .failure(_):
                XCTFail("Should not execute this block clause")
                expectation.fulfill()
            }
        }, receiveValue: { _ in
            expectation.fulfill()
        }).store(in: &cancellables)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        viewModel.play(id: song.audioContentIdentifier)
        XCTAssert(mockAudioPlayerService.isPlaying == true)
        XCTAssert(mockAudioPlayerService.currentAudioContent != nil)
    }
    
    func testPause() {
        let mockAudioPlayerService = AudioPlayerService()
        let song = mockSongs[3]
        
        XCTAssert(song.localFilePath != nil)
        mockAudioPlayerService.currentAudioContent = song
        
        viewModel = SongListViewModel(songStore: SongStore(apiClient: mockAPIClient, coreDataStore: mockCoreDataStore), downloadStore: DownloadStore(), coreDataStore: mockCoreDataStore, audioPlayerService: mockAudioPlayerService)
        
        viewModel.pause()
        XCTAssert(mockAudioPlayerService.isPlaying == false)
        XCTAssert(mockAudioPlayerService.isLoading == false)
        XCTAssert(mockAudioPlayerService.currentAudioContent != nil)
    }
}
