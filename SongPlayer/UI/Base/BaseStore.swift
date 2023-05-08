import UIKit
import Combine

class BaseStore: NSObject {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()

        // Do custom date format decoding here, if needed
        return decoder
    }()

    var cancellables: Set<AnyCancellable> = Set()
}
