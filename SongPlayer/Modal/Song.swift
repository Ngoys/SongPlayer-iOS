import Foundation
import Combine

class Song: Codable, Hashable {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    init(id: String, name: String, audioURL: URL, localFilePath: String?) {
        self.id = id
        self.name = name
        self.audioURL = audioURL
        self.localFilePath = localFilePath
        self.uiState = CurrentValueSubject<SongUIState, Never>(SongUIState())
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    let id: String
    let name: String
    let audioURL: URL
    var localFilePath: String? {
        didSet {
            if localFilePath != nil {
                var uiStateClone = self.uiState.value
                uiStateClone.status = .canPlay
                uiState.send(uiStateClone)
            }
        }
    }
    let uiState: CurrentValueSubject<SongUIState, Never>

    //----------------------------------------
    // MARK: - Coding keys
    //----------------------------------------

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case audioURL
        case localFilePath
    }

    //----------------------------------------
    // MARK: - Codable protocols
    //----------------------------------------

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        audioURL = try container.decode(URL.self, forKey: .audioURL)
        localFilePath = try container.decodeIfPresent(String.self, forKey: .localFilePath)
        uiState = CurrentValueSubject<SongUIState, Never>(SongUIState())
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(audioURL, forKey: .audioURL)
        try container.encode(localFilePath, forKey: .localFilePath)
    }

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
// MARK: - DownloadableContent protocols
//----------------------------------------

extension Song: DownloadableContent {

    var downloadContentIdentifier: String {
        return self.id
    }

    var downloadURL: URL {
        return self.audioURL
    }

    var downloadFileFormat: DownloadFileFormat {
        return .mp3
    }
}
