import Foundation

protocol DownloadableContent {
    var downloadContentIdentifier: String { get }
    var downloadURL: URL { get }
    var downloadType: DownloadType { get }
}
