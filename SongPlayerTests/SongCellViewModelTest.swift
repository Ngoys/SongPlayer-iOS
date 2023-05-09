import XCTest
import Combine
@testable import SongPlayer

class SongCellViewModelTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var viewModel: SongCellViewModel!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupViewModel() {
        viewModel = SongCellViewModel(song: mockSongs[0])
    }

    override func setUp() {
        super.setUp()
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------

    func testTitleText() {
        setupViewModel()
        
        let mockSong = mockSongs[0]
        XCTAssert(viewModel.titleText == mockSong.name)
    }

    func testStatePublisher() {
        setupViewModel()
        
        let mockSong = mockSongs[0]

        var sinkCount = 0

        viewModel.statePublisher.sink(receiveCompletion: { completion in
            switch completion {
            case .finished:
                break

            case .failure(_):
                XCTFail("Should not execute this block clause")
            }
        }, receiveValue: { value in
            sinkCount += 1

            XCTAssert(value.status == mockSong.uiStateSubject.value.status)
            XCTAssert(value.isUserFavourited == mockSong.uiStateSubject.value.isUserFavourited)
            XCTAssert(value.isTop10Song == mockSong.uiStateSubject.value.isTop10Song)
            XCTAssert(value.isFeatured == mockSong.uiStateSubject.value.isFeatured)
        }).store(in: &cancellables)

        XCTAssert(sinkCount == 1)

        var uiStateClone = mockSong.uiStateSubject.value

        uiStateClone.status = .isDownloading(progress: 0)
        mockSong.uiStateSubject.send(uiStateClone)
        XCTAssert(sinkCount == 2)

        uiStateClone.status = .isDownloading(progress: 100)
        mockSong.uiStateSubject.send(uiStateClone)
        XCTAssert(sinkCount == 3)

        uiStateClone.status = .canPlay
        uiStateClone.isFeatured = true
        mockSong.uiStateSubject.send(uiStateClone)
        XCTAssert(sinkCount == 4)

        uiStateClone.status = .canPause
        uiStateClone.isTop10Song = true
        uiStateClone.isUserFavourited = true
        mockSong.uiStateSubject.send(uiStateClone)
        XCTAssert(sinkCount == 5)
    }
}
