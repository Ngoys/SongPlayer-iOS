import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //----------------------------------------
    // MARK: - Application window
    //----------------------------------------

    var window: UIWindow?

    //----------------------------------------
    // MARK: - Application lifecycle
    //----------------------------------------

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = window!.rootViewController as! UINavigationController
        let mainViewController = navigationController.viewControllers[0] as! MainViewController

        appCoordinator = AppCoordinator(mainViewController: mainViewController)
        appCoordinator.start()

        return true
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private var appCoordinator: AppCoordinator!
}
