import XCTest
import Combine
@testable import SongPlayer

class SongCellViewModelTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var viewModel: SongCellViewModel!

    let mockSong = Song(id: "0", name: "Song1", audioURL: URL(string: "https://drive.google.com/uc?export=download&id=16-NMvJH4aJSgDpM66RizWe2qjHOP6n8f")!, localFilePath: nil)

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupViewModel() {
        viewModel = SongCellViewModel(song: mockSong)
    }

    override func setUp() {
        super.setUp()
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------

    func testTitleText() {
        setupViewModel()
        XCTAssertEqual(viewModel.titleText, mockSong.name)
    }

    func testStatePublisher() {
        setupViewModel()

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

            XCTAssert(value.status == self.mockSong.uiStateSubject.value.status)
            XCTAssert(value.isUserFavourited == self.mockSong.uiStateSubject.value.isUserFavourited)
            XCTAssert(value.isTop10Song == self.mockSong.uiStateSubject.value.isTop10Song)
            XCTAssert(value.isFeatured == self.mockSong.uiStateSubject.value.isFeatured)
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
