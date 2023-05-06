import UIKit
import Combine

protocol MainViewControllerDelegate: NSObjectProtocol {
}

class MainViewController: BaseViewController {

    //----------------------------------------
    // MARK: - Configure views
    //----------------------------------------

    override func configureViews() {
    }
    
    //----------------------------------------
    // MARK: - Bind view model
    //----------------------------------------

    override func bindViewModel() {

    }

    //----------------------------------------
    // MARK: - View model
    //----------------------------------------

    var viewModel: MainViewModel!

    //----------------------------------------
    // MARK: - Delegate
    //----------------------------------------

    weak var delegate: MainViewControllerDelegate?
}
