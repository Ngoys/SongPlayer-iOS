import Foundation

class BasicDownloadManager: DownloadManager {

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func download(contentIdentifier: String, downloadURL: URL) -> DownloadItem {
        // Future expansion
        return DownloadItem(contentIdentifier: contentIdentifier, downloadURL: downloadURL, status: .error(downloadError: DownloadError.notSupportedYet))
    }
}
