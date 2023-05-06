import UIKit

protocol SongListViewControllerDelegate: NSObjectProtocol {

}

class SongListViewController: BaseViewController {

    class func fromStoryboard() -> (UINavigationController, SongListViewController) {
        let navigationController = UIStoryboard(name: "SongList", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let viewController = navigationController.topViewController
        return (navigationController, viewController as! SongListViewController)
    }

    //----------------------------------------
    // MARK: - View model
    //----------------------------------------

    var viewModel: SongListViewModel!

    //----------------------------------------
    // MARK: - Delegate
    //----------------------------------------

    weak var delegate: SongListViewControllerDelegate?

    //----------------------------------------
    // MARK: - Configure views
    //----------------------------------------

    override func configureViews() {
        ServiceContainer.container.resolve(type: SongStore.self).fetchSongs().sink { com in

        } receiveValue: { value in
            print(value)
        }.store(in: &cancellables)

    }

    //----------------------------------------
    // MARK: - Bind view model
    //----------------------------------------

    override func bindViewModel() {
    }
}
