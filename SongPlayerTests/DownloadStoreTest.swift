import XCTest
import Combine
@testable import SongPlayer

class DownloadStoreTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var store: DownloadStore!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupStore() {
        store = DownloadStore()
    }

    override func setUp() {
        super.setUp()
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------
    
    func testDownloadingItemsPublisher() {
        setupStore()
        
        var sinkCount = 0
        
        let expectation = expectation(description: "Wait for downloadingItemsPublisher sink")
        
        store.downloadingItemsPublisher.sink(receiveValue: { downloadingItems in
            XCTAssert(downloadingItems.count == sinkCount)
            
            if sinkCount == 2 {
                XCTAssert(downloadingItems[0].contentIdentifier == self.mockSongs[0].downloadContentIdentifier)
                XCTAssert(downloadingItems[1].contentIdentifier == self.mockSongs[1].downloadContentIdentifier)
                
                expectation.fulfill()
            }
            
            sinkCount += 1
        }).store(in: &cancellables)
        
        _ = store.download(contentIdentifier: mockSongs[0].downloadContentIdentifier, downloadURL: mockSongs[0].downloadURL, downloadFileFormat: mockSongs[0].downloadFileFormat)
        
        _ = store.download(contentIdentifier: mockSongs[1].downloadContentIdentifier, downloadURL: mockSongs[1].downloadURL, downloadFileFormat: mockSongs[1].downloadFileFormat)
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testNotSupportedYetDownloadError() {
        setupStore()
        
        var sinkCount = 0
        
        let expectation = expectation(description: "Wait for downloadingItemsPublisher sink")
        
        store.downloadingItemsPublisher.sink(receiveValue: { downloadingItems in
            if sinkCount == 2 {
                XCTAssert(downloadingItems.count == 0)
                expectation.fulfill()
            }
            
            sinkCount += 1
        }).store(in: &cancellables)
        
        let downloadItem1 = store.download(contentIdentifier: DownloadFileFormat.chatHistory.rawValue, downloadURL: mockSongs[0].downloadURL, downloadFileFormat: .chatHistory)
        XCTAssert(downloadItem1.statusSubject.value == .error(downloadError: .notSupportedYet))
        
        let downloadItem2 = store.download(contentIdentifier: DownloadFileFormat.theme.rawValue, downloadURL: mockSongs[1].downloadURL, downloadFileFormat: .theme)
        XCTAssert(downloadItem2.statusSubject.value == .error(downloadError: .notSupportedYet))
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
