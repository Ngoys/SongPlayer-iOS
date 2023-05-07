import Foundation
import Combine

class DownloadItem {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(contentIdentifier: String, downloadURL: URL, status: DownloadStatus = .queued) {
        self.contentIdentifier = contentIdentifier
        self.downloadURL = downloadURL
        self.startDate = Date()
        self.status = status
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    let contentIdentifier: String
    let downloadURL: URL
    let startDate: Date
    private(set) var finishedDate: Date?

    var statusDidChange = PassthroughSubject<DownloadStatus, Never>()
    var status: DownloadStatus = .queued {
        didSet {
            self.finishedDate = Date()
            statusDidChange.send(status)
        }
    }
}
