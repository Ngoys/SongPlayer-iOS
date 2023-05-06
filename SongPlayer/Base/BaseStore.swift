import UIKit
import Combine

class BaseStore: NSObject {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var cancellables: Set<AnyCancellable> = Set()
}
