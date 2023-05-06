import Foundation
import UIKit

extension UIView {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }

        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
}
