import Foundation

protocol DownloadableContent {
    var downloadContentIdentifier: String { get }
    var downloadURL: URL { get }
    var downloadFileFormat: DownloadFileFormat { get }
}
