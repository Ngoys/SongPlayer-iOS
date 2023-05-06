import Foundation
import UIKit
import Combine

class BaseUICollectionViewCell: UICollectionViewCell {

    //----------------------------------------
    // MARK: - Lifecycle
    //----------------------------------------

    override func prepareForReuse() {
        super.prepareForReuse()

        cancellables.removeAll()
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var cancellables: Set<AnyCancellable> = Set()
}
