import Foundation

extension FileManager {

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
