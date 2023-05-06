import Foundation

struct Song: Codable, Hashable {
    let id: String
    let name: String
    let audioURL: URL

    //----------------------------------------
    // MARK: - Hashable protocols
    //----------------------------------------

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Song, rhs: Song) -> Bool {
        lhs.id == rhs.id
    }
}

//----------------------------------------
// MARK: - DownloadableContent
//----------------------------------------

extension Song: DownloadableContent {

    var downloadContentIdentifier: String {
        return self.id
    }

    var downloadURL: URL {
        return self.audioURL
    }

    var downloadType: DownloadType {
        return .mp3
    }
}
