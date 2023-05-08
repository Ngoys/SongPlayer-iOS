import Foundation

// Future expansion
class ChatHistoryDownloadManager: BaseDownloadManager {

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    override func download(contentIdentifier: String, downloadURL: URL, downloadFileFormat: DownloadFileFormat) -> DownloadItem {
        // For example,
        // Download user chat history and storing it accordingly with the localFilePath
        // localFilePath could be "Downloads/ChatHistory/{PersonName}/{Date}/chatHistory.json
        return DownloadItem(contentIdentifier: contentIdentifier, downloadURL: downloadURL, status: .error(downloadError: .notSupportedYet))
    }
}
