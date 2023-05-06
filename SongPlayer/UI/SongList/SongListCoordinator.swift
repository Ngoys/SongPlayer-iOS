import UIKit
import CoreLocation

protocol SongListCoordinatorDelegate: NSObjectProtocol {
}

class SongListCoordinator: BaseCoordinator {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(songListViewController: SongListViewController) {
        songListViewController.viewModel = SongListViewModel(songStore: ServiceContainer.container.resolve(type: SongStore.self))

        self.songListViewController = songListViewController
    }

    //----------------------------------------
    // MARK: - Delegate
    //----------------------------------------

    weak var delegate: SongListCoordinatorDelegate?

    //----------------------------------------
    // MARK: - Starting flows
    //----------------------------------------

    func start() {
        self.songListViewController.delegate = self
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let songListViewController: SongListViewController
}

//----------------------------------------
// MARK: - SongListViewController delegate
//----------------------------------------

extension SongListCoordinator: SongListViewControllerDelegate {

}
