import Foundation

extension String {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
