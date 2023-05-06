import UIKit
import Combine
import Foundation

class AppCoordinator: BaseCoordinator {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(mainViewController: MainViewController) {
        self.mainViewController = mainViewController

        super.init()

        mainViewController.delegate = self
        mainViewController.viewModel = MainViewModel()
    }

    //----------------------------------------
    // MARK: - Starting Flows
    //----------------------------------------

    func start() {
        startMainFlow()
    }

    //----------------------------------------
    // MARK: - Main Flow
    //----------------------------------------

    private func startMainFlow() {
        let (navigationController, songListViewController) = SongListViewController.fromStoryboard()

        mainViewController.addChild(navigationController)
        mainViewController.view.addSubview(navigationController.view)
        let constraints = [
            navigationController.view.leadingAnchor.constraint(equalTo: mainViewController.view.leadingAnchor),
            navigationController.view.trailingAnchor.constraint(equalTo: mainViewController.view.trailingAnchor),
            navigationController.view.topAnchor.constraint(equalTo: mainViewController.view.topAnchor),
            navigationController.view.bottomAnchor.constraint(equalTo: mainViewController.view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        navigationController.didMove(toParent: mainViewController)

        let songListCoordinator = SongListCoordinator(songListViewController: songListViewController)
        songListCoordinator.delegate = self
        songListCoordinator.start()

        self.songListCoordinator = songListCoordinator
        self.activeViewController = songListViewController
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let mainViewController: MainViewController

    private var activeViewController: UIViewController?

    private var songListCoordinator: SongListCoordinator?
}

//----------------------------------------
// MARK: - MainViewController Delegate
//----------------------------------------

extension AppCoordinator: MainViewControllerDelegate {
}

//----------------------------------------
// MARK: - SongListCoordinator Delegate
//----------------------------------------

extension AppCoordinator: SongListCoordinatorDelegate {
}
