import Foundation

class ServiceContainer {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    private init() {}

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    private static var _container: ServiceContainer?
    static var container: ServiceContainer {
        // Normally for Dependency Injection, I would use Swinject library
        // Here, I used Singleton concept with dictionary to store initialized dependencies
        // https://medium.com/sahibinden-technology/dependency-injection-in-swift-11756a07a064

        if _container == nil {
            let container = ServiceContainer()
            
            container.register(type: HTTPClient.self, service: HTTPClient())
            
            container.register(type: SongPlayerAPIClient.self,
                                service: SongPlayerAPIClient(apiBaseURL: AppConstant.baseURL, httpClient: container.resolve(type: HTTPClient.self)))
            
            //----------------------------------------
            // MARK: - Stores and Services
            //----------------------------------------
            
            container.register(type: AudioPlayerService.self,
                                service: AudioPlayerService())
            
            container.register(type: CoreDataStack.self,
                                service: CoreDataStack())
            
            container.register(type: CoreDataStore.self,
                                service: CoreDataStore(coreDataStack: container.resolve(type: CoreDataStack.self)))
            
            container.register(type: SongStore.self,
                                service: SongStore(apiClient: container.resolve(type: SongPlayerAPIClient.self), coreDataStore: container.resolve(type: CoreDataStore.self)))
            
            container.register(type: DownloadStore.self,
                                service: DownloadStore())

            _container = container
        }
        return _container!
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    private func register<T>(type: T.Type, service: Any) {
        services["\(type)"] = service
    }

    func resolve<T>(type: T.Type) -> T {
        return services["\(type)"] as! T
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private var services: [String: Any] = [:]
}
