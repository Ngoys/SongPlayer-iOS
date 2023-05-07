import UIKit
import CoreLocation

protocol SongListCoordinatorDelegate: NSObjectProtocol {
}

class SongListCoordinator: BaseCoordinator {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(songListViewController: SongListViewController) {
        songListViewController.viewModel = SongListViewModel(songStore: ServiceContainer.container.resolve(type: SongStore.self), downloadStore: ServiceContainer.container.resolve(type: DownloadStore.self), coreDataStore: ServiceContainer.container.resolve(type: CoreDataStore.self), audioPlayerService: ServiceContainer.container.resolve(type: AudioPlayerService.self))

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
