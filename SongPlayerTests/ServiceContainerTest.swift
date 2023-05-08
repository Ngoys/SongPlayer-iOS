import XCTest
import Combine
@testable import SongPlayer

class ServiceContainerTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var container: ServiceContainer!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupServiceContainer() {
        container = ServiceContainer.container
    }

    override func setUp() {
        super.setUp()
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------

    func testReferences() {
        XCTAssert(ServiceContainer.container.resolve(type: SongStore.self) === ServiceContainer.container.resolve(type: SongStore.self))
        XCTAssert(ServiceContainer.container.resolve(type: CoreDataStore.self) === ServiceContainer.container.resolve(type: CoreDataStore.self))
        XCTAssert(ServiceContainer.container.resolve(type: AudioPlayerService.self) === ServiceContainer.container.resolve(type: AudioPlayerService.self))
        XCTAssert(ServiceContainer.container.resolve(type: DownloadStore.self) === ServiceContainer.container.resolve(type: DownloadStore.self))
    }
}
