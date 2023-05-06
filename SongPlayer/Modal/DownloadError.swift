import Foundation

enum DownloadError: Error {
    case invalidURL
    case diskNotEnoughSpace
    case badRequest
    case internetDisconnected
    case notSupportedYet

    //LALA alert prompt error mssage
}
