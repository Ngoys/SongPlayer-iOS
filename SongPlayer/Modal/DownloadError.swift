import Foundation

enum DownloadError: Error {
    case invalidURL
    case diskNotEnoughSpace
    case badRequest
    case internetDisconnected
    case notSupportedYet

    //TODO alert prompt error mssage
}
