import Foundation

enum DownloadError: Error {
    case invalidURL
    case diskNotEnoughSpace
    case badRequest
    case invalidFilePath
    case internetDisconnected
    case notSupportedYet

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var errorAlertDialog: AlertDialogModel {
        switch self {
        case .notSupportedYet:
            return NotSupportedYetDialog()

        case .diskNotEnoughSpace:
            return DownloadDiskNotEnoughSpaceDialog()

        case .internetDisconnected:
            return NoInternetErrorDialog()

        case .invalidURL:
            return DownloadInvalidURLDialog()

        default:
            return GeneralErrorDialog()
        }
    }
}
