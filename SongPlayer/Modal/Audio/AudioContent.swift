import Foundation

protocol AudioContent: AnyObject {
    var audioContentIdentifier: String { get }
    var audioContentType: AudioContentType { get }
    var audioContentURL: URL? { get }
    var audioContentTitle: String? { get }
}

extension AudioContent {

    var audioContentType: AudioContentType {
        // Provide a default value for the type for all modals,
        // Will only declare a .livestream on LiveStreamRadio modal in the future
        return .audioClip
    }
}
