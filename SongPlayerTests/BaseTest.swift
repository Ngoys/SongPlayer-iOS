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
    
    var mockCoreDataStore: CoreDataStore!

    let today = Date()
    var tomorrow: Date!

    var apiBaseURL = AppConstant.baseURL

    var cancellables: Set<AnyCancellable> = Set()
    
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
          "audioURL": "https://drive.google.com/uc?export=download&id=1N3EW3CeY1v1L1bM4CtO5Fux1CYm5ZTLe",
          "localFilePath": "\(FileManager.default.downloadDirectoryPathURL!.absoluteString)/1.mp3",
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

    override func setUp() {
        let jsonData = songsJSON.data(using: .utf8)!
        mockSongs = try! JSONDecoder().decode([Song].self, from: jsonData)
        mockSongs.append(Song(id: "3", name: "Song 4", audioURL: URL(string: "https://drive.google.com/uc?export=download&id=1g9FC6LhQUgUa_jO-xPxi7PdRKpZVyina")!, localFilePath: "Downloads/4.mp3"))
        
        let calendar = Calendar.current
        tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: today))!

        mockCoreDataStack = CoreDataStack()
        mockHTTPClient = HTTPClient()
        mockAPIClient = SongPlayerAPIClient(apiBaseURL: apiBaseURL, httpClient: mockHTTPClient)
        
        mockCoreDataStore = CoreDataStore(coreDataStack: mockCoreDataStack)
        mockCoreDataStore.deleteAllSongs()
        
        cancellables.removeAll()
    }
}
