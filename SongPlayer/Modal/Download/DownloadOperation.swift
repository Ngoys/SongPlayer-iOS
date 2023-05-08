import Foundation
import Combine

class DownloadOperation: Operation {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(urlSession: URLSession, contentIdentifier: String, downloadURL: URL) {
        self.urlSession = urlSession
        self.contentIdentifier = contentIdentifier
        self.downloadURL = downloadURL

        super.init()

        self.qualityOfService = .background

        //----------------------------------------
        // MARK: - Start observing data
        //----------------------------------------

        downloadStatusSubject
            .sink { [weak self] status in
            guard let self = self else { return }

            switch status {
            case .downloaded(_):
                self.state = .finished

            case .error(_):
                self.state = .finished

            case .downloading(_):
                if self.state != .executing {
                    self.state = .executing
                }

            default:
                self.state = .ready
            }
        }.store(in: &cancellables)
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    // Override Operation state
    // https://fluffy.es/download-files-sequentially/
    private enum OperationState : Int {
        case ready
        case executing
        case finished
    }

    private var state : OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }

        didSet {
            print("DownloadOperation - state - didSet - \(state)")
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }

    override var isReady: Bool { return state == .ready }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }

    private(set) var task: URLSessionDownloadTask?
    let contentIdentifier: String
    var downloadStatusSubject = PassthroughSubject<DownloadStatus, Never>()

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    override func start() {
        self.task = self.urlSession.downloadTask(with: self.downloadURL)

        downloadStatusSubject.send(.downloading(progress: 0))

        // Start the download
        self.task?.resume()
    }

    override func cancel() {
        super.cancel()

        downloadStatusSubject.send(.queued)

        self.task?.cancel()
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let downloadURL: URL

    private let urlSession: URLSession

    private var cancellables: Set<AnyCancellable> = Set()
}
