import Foundation
import Combine

enum State<T> {
    case loading
    case loadingNextPage
    case loadingFailed(Error)
    case retryingLoad
    case loaded(T)
    case manualReloading(T)
    case manualReloadingFailed(T, Error)
}

enum Event<T> {
    case retryInitialLoad
    case manualReload
    case proceedFromManualReloadingFailed
    case loadSuccess(T)
    case loadNextPage
    case loadFailure(Error)
}

class StatefulViewModel<T>: BaseViewModel {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    override init() {
        super.init()

        proceedToLoad()
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func load() -> AnyPublisher<T, Error> {
        fatalError("\(#function) must be overridden by subclasses")
    }

    func loadNextPage() {
        // Load next page only when the current state is loaded or manual reloading failed
        switch stateSubject.value {
        case .manualReloadingFailed, .loaded:
            break

        default:
            return
        }

        pageNumber += 1
        transition(with: .loadNextPage)
    }

    private func proceedToLoad() {
        load().sink { completion in
            switch completion {
            case .finished:
                break

            case .failure(let error):
                self.transition(with: .loadFailure(error))
            }
        } receiveValue: { data in
            self.transition(with: .loadSuccess(data))
        }.store(in: &cancellables)
    }

    func retryInitialLoad() {
        pageNumber = 1
        transition(with: .retryInitialLoad)
    }

    func reloadManually() {
        pageNumber = 1
        transition(with: .manualReload)
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    private let stateSubject = CurrentValueSubject<State<T>, Never>(.loading)
    var statePublisher: AnyPublisher<State<T>, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    var pageNumber: Int = 1

    //----------------------------------------
    // MARK: - Transition
    //----------------------------------------

    private func transition(with event: Event<T>) {
        switch (stateSubject.value, event) {
        case (.loading, .loadSuccess(let data)):
            print("StatefulViewModel - transition from \(stateSubject.value) to .loadSuccess")
            stateSubject.send(.loaded(data))

        case (.loadingNextPage, .loadSuccess(let data)):
            print("StatefulViewModel - transition from \(stateSubject.value) to .loadSuccess")
            stateSubject.send(.loaded(data))

        case (.loading, .loadFailure(let error)):
            print("StatefulViewModel - transition from \(stateSubject.value) to \(event) with error: \(error)")
            stateSubject.send(.loadingFailed(error))

        case (.loaded, .retryInitialLoad):
            print("StatefulViewModel - transition from \(stateSubject.value) to \(event)")
            stateSubject.send(.retryingLoad)
            proceedToLoad()

        case (.loadingFailed, .retryInitialLoad):
            print("StatefulViewModel - transition from \(stateSubject.value) to \(event)")
            stateSubject.send(.retryingLoad)
            proceedToLoad()

        case (.retryingLoad, .loadSuccess(let data)):
            print("StatefulViewModel - transition from \(stateSubject.value) to \(event)")
            stateSubject.send(.loaded(data))

        case (.retryingLoad, .loadFailure(let error)):
            print("StatefulViewModel - transition from \(stateSubject.value) to \(event) with error: \(error)")
            stateSubject.send(.loadingFailed(error))

        case (.loaded(let data), .manualReload):
            print("StatefulViewModel - transition from \(stateSubject.value) to \(event)")
            stateSubject.send(.manualReloading(data))
            proceedToLoad()

        case (.loaded(let data), .loadNextPage):
            print("StatefulViewModel - transition from \(stateSubject.value) to \(event)")
            stateSubject.send(.loadingNextPage)
            proceedToLoad()

        case (.manualReloading(let data), .loadNextPage):
            print("StatefulViewModel - transition from \(stateSubject.value) to \(event)")
            stateSubject.send(.loadingNextPage)
            proceedToLoad()

        case (.loadingFailed, .manualReload):
            print("StatefulViewModel - transition from \(stateSubject.value) to \(event)")
            stateSubject.send(.loading)
            proceedToLoad()

        case (.manualReloading, .loadSuccess(let data)):
            print("StatefulViewModel - transition from \(stateSubject.value) to \(event)")
            stateSubject.send(.loaded(data))

        case (.manualReloading(let data), .loadFailure(let error)):
            print("StatefulViewModel - transition from \(stateSubject.value) to \(event) with error: \(error)")
            stateSubject.send(.manualReloadingFailed(data, error))

            // Transition away from manualReloadingFailed immediately.
            DispatchQueue.main.async { [weak self] in
                self?.transition(with: .proceedFromManualReloadingFailed)
            }

        case (.manualReloadingFailed(let data, _), .proceedFromManualReloadingFailed):
            print("StatefulViewModel - transition from \(stateSubject.value) to \(event)")
            stateSubject.send(.loaded(data))

        default:
            print("StatefulViewModel - invalid event for state: \(stateSubject.value), \(event)")
            stateSubject.send(.retryingLoad)
            proceedToLoad()
        }
    }
}
