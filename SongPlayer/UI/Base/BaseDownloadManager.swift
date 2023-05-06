import UIKit
import Combine

class BaseDownloadManager: NSObject, DownloadManager {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var cancellables: Set<AnyCancellable> = Set()

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func download(contentIdentifier: String, downloadURL: URL, downloadFileFormat: DownloadFileFormat) -> DownloadItem {
        fatalError("download method must be implemented !!!")
    }
}
