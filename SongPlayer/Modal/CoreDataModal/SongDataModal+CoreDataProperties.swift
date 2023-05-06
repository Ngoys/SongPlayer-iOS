import Foundation
import CoreData

extension SongDataModal {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var audioURL: URL
    @NSManaged public var localFilePath: String?

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    static func fetchRequest() -> NSFetchRequest<SongDataModal> {
        return NSFetchRequest<SongDataModal>(entityName: String(describing: SongDataModal.self))
    }

    func toSong() -> Song {
        return Song(id: id, name: name, audioURL: audioURL)
    }
}
