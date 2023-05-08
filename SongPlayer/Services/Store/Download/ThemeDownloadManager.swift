import Foundation

// Future expansion
class ThemeDownloadManager: BaseDownloadManager {

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------
    
    override func download(contentIdentifier: String, downloadURL: URL, downloadFileFormat: DownloadFileFormat) -> DownloadItem {
        // For example,
        // Download themes and storing it in separated DataModals in Core Data
        // Then, the theme can be applied to the music player or user interface
        return DownloadItem(contentIdentifier: contentIdentifier, downloadURL: downloadURL, status: .error(downloadError: .notSupportedYet))
    }
}
