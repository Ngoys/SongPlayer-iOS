import Foundation

class SongPlayerDateFormatter {

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    static func relativeDateFormatter(fromDate: Date?,
                                      doesRelativeDateFormatting: Bool = true) -> String {
        guard let date = fromDate else {
            return "-"
        }

        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = doesRelativeDateFormatting
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long

        return dateFormatter.string(from: date)
    }
}
