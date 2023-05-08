import Foundation

enum DownloadFileFormat: String {
    case mp3
    case jpg
    case png
    case pdf
    case zip
    case mp4

    // Future expansion
    // If these file types need special downloading mechanism,
    // We can have more types of DownloadManager
    case chatHistory
    case theme
}
