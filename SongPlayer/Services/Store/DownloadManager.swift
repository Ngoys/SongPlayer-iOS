import Foundation

protocol DownloadManager {
    func download(contentIdentifier: String, downloadURL: URL, downloadFileFormat: DownloadFileFormat) -> DownloadItem
}
