import Foundation

extension FileManager {
    
    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------
    
    var downloadDirectoryPathURL: URL? {
        return URL(string: "Downloads")
    }
    
    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------
    
    func getDocumentDirectoryFolderURL() throws -> URL {
        return try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
    }
}
