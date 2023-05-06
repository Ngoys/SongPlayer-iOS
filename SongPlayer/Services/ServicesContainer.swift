import Foundation

class ServiceContainer {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    private init() {}

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    static var container: ServiceContainer {
        // https://medium.com/sahibinden-technology/dependency-injection-in-swift-11756a07a064

        let container = ServiceContainer()

        container.register(type: HTTPClient.self, service: HTTPClient())

        container.register(type: SongPlayerAPIClient.self,
                           service: SongPlayerAPIClient(apiBaseURL: AppConstant.baseURL, httpClient: container.resolve(type: HTTPClient.self)!))

        container.register(type: SongStore.self,
                           service: SongStore(apiClient: container.resolve(type: SongPlayerAPIClient.self)!))

        return container
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    private func register<T>(type: T.Type, service: Any) {
        services["\(type)"] = service
    }

    func resolve<T>(type: T.Type) -> T? {
        return services["\(type)"] as? T
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private var services: [String: Any] = [:]
}
