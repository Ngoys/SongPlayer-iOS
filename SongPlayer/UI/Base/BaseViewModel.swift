import UIKit
import Combine

class BaseViewModel: NSObject {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var promptUIAlertController = PassthroughSubject<AlertDialogModel, Never>()

    var cancellables: Set<AnyCancellable> = Set()
}
