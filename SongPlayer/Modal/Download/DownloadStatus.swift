import Foundation

enum DownloadStatus: Equatable {
    case queued
    case downloading(progress: Double)
    case downloaded(localFilePath: String)
    case error(downloadError: DownloadError)
}
