import Foundation

class VideoDownloadManager: BaseDownloadManager {

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    override func download(contentIdentifier: String, downloadURL: URL, downloadFileFormat: DownloadFileFormat) -> DownloadItem {
        // Future expansion
        return DownloadItem(contentIdentifier: contentIdentifier, downloadURL: downloadURL, status: .error(downloadError: DownloadError.notSupportedYet))
    }
}
