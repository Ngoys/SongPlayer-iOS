import Foundation

protocol DownloadManager {
    func download(contentIdentifier: String, downloadURL: URL, downloadType: DownloadType) -> DownloadItem
}
