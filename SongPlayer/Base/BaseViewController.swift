import UIKit
import Combine

class BaseViewController: UIViewController {

    //----------------------------------------
    // MARK: - Lifecycle
    //----------------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        bindViewModel()
    }

    //----------------------------------------
    // MARK: - Configure Views
    //----------------------------------------

    func configureViews() {
        fatalError("configureViews method must be implemented !!!")
    }

    //----------------------------------------
    // MARK: - Bind View Model
    //----------------------------------------

    func bindViewModel() {
        fatalError("bindViewModel method must be implemented !!!")
    }

    //----------------------------------------
    // MARK: - Deinitialization
    //----------------------------------------

    deinit {
        cancellables.forEach { $0.cancel() }
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    var cancellables: Set<AnyCancellable> = Set()
}
