import UIKit
import Combine

class BaseViewModel: NSObject {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var cancellables: Set<AnyCancellable> = Set()
}
