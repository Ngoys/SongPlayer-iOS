import XCTest
import Combine
@testable import SongPlayer

class CoreDataStoreTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var store: CoreDataStore!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupStore() {
        mockCoreDataStore = CoreDataStore(coreDataStack: mockCoreDataStack)
        mockCoreDataStore.deleteAllSongs()
    }

    override func setUp() {
        super.setUp()
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------
    
    func testCreateOrUpdateSong() {
        setupStore()
        
        let firstSong = mockSongs[0]
        let secondSong = mockSongs[1]
        mockCoreDataStore.createOrUpdateSong(song: firstSong)
        mockCoreDataStore.createOrUpdateSong(song: secondSong)
        
        let offlineSongs = mockCoreDataStore.fetchAllSongs()
        XCTAssert(offlineSongs.count == 2)
        
        let offlineFirstSong = offlineSongs[0]
        let offlineSecondSong = offlineSongs[1]
        
        XCTAssert(offlineFirstSong.id == firstSong.id)
        XCTAssert(offlineFirstSong.name == firstSong.name)
        XCTAssert(offlineFirstSong.audioContentURL == firstSong.audioContentURL)
        XCTAssert(offlineFirstSong.localFilePath == firstSong.localFilePath)
        XCTAssert(offlineFirstSong.uiStateSubject.value == firstSong.uiStateSubject.value)
        
        XCTAssert(offlineSecondSong.id == secondSong.id)
        XCTAssert(offlineSecondSong.name == secondSong.name)
        XCTAssert(offlineSecondSong.audioContentURL == secondSong.audioContentURL)
        XCTAssert(offlineSecondSong.localFilePath == secondSong.localFilePath)
        XCTAssert(offlineSecondSong.uiStateSubject.value == secondSong.uiStateSubject.value)
    }
    
    func testUpdateSongLocalFilePath() {
        setupStore()
        
        let firstSong = mockSongs[0]
        mockCoreDataStore.createOrUpdateSong(song: firstSong)
        
        var songs = mockCoreDataStore.fetchAllSongs()
        XCTAssert(songs.count == 1)
        
        let song = songs[0]
        XCTAssert(song.id == firstSong.id)
        XCTAssert(song.name == firstSong.name)
        XCTAssert(song.audioContentURL == firstSong.audioContentURL)
        XCTAssert(song.localFilePath == firstSong.localFilePath)
        XCTAssert(song.uiStateSubject.value == firstSong.uiStateSubject.value)
        
        firstSong.localFilePath = "\(FileManager.default.downloadDirectoryPathURL!.absoluteString).\(firstSong.id).mp3"
        mockCoreDataStore.updateSongLocalFilePath(id: firstSong.id, localFilePath: firstSong.localFilePath ?? "")
        
        songs = mockCoreDataStore.fetchAllSongs()
        XCTAssert(songs.count == 1)
        XCTAssert(song.localFilePath == songs[0].localFilePath)
    }

    func testDeleteAllSongs() {
        setupStore()
        
        let firstSong = mockSongs[0]
        let secondSong = mockSongs[1]
        mockCoreDataStore.createOrUpdateSong(song: firstSong)
        mockCoreDataStore.createOrUpdateSong(song: secondSong)
        
        XCTAssert(mockCoreDataStore.fetchAllSongs().count == 2)
        
        mockCoreDataStore.deleteAllSongs()
        XCTAssert(mockCoreDataStore.fetchAllSongs().count == 0)
    }
}
