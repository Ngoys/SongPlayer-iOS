import Foundation

extension Array where Element: Hashable {

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    mutating func removeDuplicates() {
        // https://www.hackingwithswift.com/example-code/language/how-to-remove-duplicate-items-from-an-array
        var addedDict = [Element: Bool]()

        self = filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
}
