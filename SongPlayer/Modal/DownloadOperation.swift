import Foundation
import Combine

//LALA override all the .isReady state here??
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
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    private(set) var task: URLSessionDownloadTask?
    let urlSession: URLSession
    let contentIdentifier: String
    let downloadURL: URL
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
}
