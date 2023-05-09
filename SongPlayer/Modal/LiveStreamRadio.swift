import Foundation
import Combine

// Future expansion
// A modal created for handling livestream radio
class LiveStreamRadio: Codable, Hashable {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(id: String, name: String, audioURL: URL) {
        self.id = id
        self.name = name
        self.audioURL = audioURL
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    let id: String
    let name: String
    let audioURL: URL

    //----------------------------------------
    // MARK: - Hashable protocols
    //----------------------------------------

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: LiveStreamRadio, rhs: LiveStreamRadio) -> Bool {
        lhs.id == rhs.id
    }
}

//----------------------------------------
// MARK: - AudioContent protocols
//----------------------------------------

extension LiveStreamRadio: AudioContent {

    var audioContentIdentifier: String {
        return self.id
    }
    
    var audioContentURL: URL? {
        return self.audioURL
    }

    var audioContentTitle: String? {
        return self.name
    }
    
    var audioContentType: AudioContentType {
        return .livestream
    }
}
