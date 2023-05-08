import Foundation

protocol AlertDialogModel {
    var title: String { get set }
    var message: String { get set }
    var positiveCTA: String { get set }
    var neutralCTA: String { get set }
    var negativeCTA: String { get set }
}

struct DownloadInvalidURLDialog: AlertDialogModel {
    var title: String
    var message: String
    var positiveCTA: String
    var neutralCTA: String
    var negativeCTA: String

    init(title: String = "error.invalidURL.title".localized,
         message: String = "error.invalidURL.message".localized,
         positiveCTA: String = "ok".localized,
         neutralCTA: String = "",
         negativeCTA: String = "") {
        self.title = title
        self.message = message
        self.positiveCTA = positiveCTA
        self.neutralCTA = neutralCTA
        self.negativeCTA = negativeCTA
    }
}

struct DownloadDiskNotEnoughSpaceDialog: AlertDialogModel {
    var title: String
    var message: String
    var positiveCTA: String
    var neutralCTA: String
    var negativeCTA: String

    init(title: String = "error.diskNotEnoughSpace.title".localized,
         message: String = "error.diskNotEnoughSpace.message".localized,
         positiveCTA: String = "ok".localized,
         neutralCTA: String = "",
         negativeCTA: String = "") {
        self.title = title
        self.message = message
        self.positiveCTA = positiveCTA
        self.neutralCTA = neutralCTA
        self.negativeCTA = negativeCTA
    }
}

struct GeneralErrorDialog: AlertDialogModel {
    var title: String
    var message: String
    var positiveCTA: String
    var neutralCTA: String
    var negativeCTA: String

    init(title: String = "error.something_went_wrong".localized,
         message: String = "error.please_try_again_later".localized,
         positiveCTA: String = "ok".localized,
         neutralCTA: String = "",
         negativeCTA: String = "") {
        self.title = title
        self.message = message
        self.positiveCTA = positiveCTA
        self.neutralCTA = neutralCTA
        self.negativeCTA = negativeCTA
    }
}

struct NoInternetErrorDialog: AlertDialogModel {
    var title: String
    var message: String
    var positiveCTA: String
    var neutralCTA: String
    var negativeCTA: String

    init(title: String = "error.offline.title".localized,
         message: String = "error.offline.message".localized,
         positiveCTA: String = "ok".localized,
         neutralCTA: String = "",
         negativeCTA: String = "") {
        self.title = title
        self.message = message
        self.positiveCTA = positiveCTA
        self.neutralCTA = neutralCTA
        self.negativeCTA = negativeCTA
    }
}

struct NotSupportedYetDialog: AlertDialogModel {
    var title: String
    var message: String
    var positiveCTA: String
    var neutralCTA: String
    var negativeCTA: String

    init(title: String = "error.notSupportedYet.title".localized,
         message: String = "error.notSupportedYet.message".localized,
         positiveCTA: String = "ok".localized,
         neutralCTA: String = "",
         negativeCTA: String = "") {
        self.title = title
        self.message = message
        self.positiveCTA = positiveCTA
        self.neutralCTA = neutralCTA
        self.negativeCTA = negativeCTA
    }
}
