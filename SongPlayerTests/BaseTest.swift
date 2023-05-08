import XCTest
import Combine
@testable import SongPlayer

class BaseTest: XCTestCase {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var mockAPIClient: APIClient!

    var mockHTTPClient: HTTPClient!

    var mockCoreDataStack: CoreDataStack!

    let today = Date()
    var tomorrow: Date!

    let apiBaseURL = AppConstant.baseURL

    var cancellables: Set<AnyCancellable> = Set()

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    override func setUp() {
        midnight = calendar.startOfDay(for: today)
        tomorrow = calendar.date(byAdding: .day, value: 1, to: midnight)!

        let coreDataStack = CoreDataStack()

        mockHTTPClient = HTTPClient()
        mockAPIClient = SongPlayerAPIClient(apiBaseURL: apiBaseURL, httpClient: mockHTTPClient)
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let calendar = Calendar.current

    private var midnight: Date!
}
