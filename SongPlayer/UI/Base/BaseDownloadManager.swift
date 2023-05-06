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

    func download(contentIdentifier: String, downloadURL: URL, downloadType: DownloadType) -> DownloadItem {
        fatalError("download method must be implemented !!!")
    }
}
