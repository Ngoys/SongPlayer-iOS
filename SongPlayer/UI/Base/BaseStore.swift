import UIKit
import Combine

class BaseStore: NSObject {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()

    var cancellables: Set<AnyCancellable> = Set()
}
