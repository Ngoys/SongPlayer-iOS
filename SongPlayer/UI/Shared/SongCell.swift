import UIKit

class SongCell: BaseUICollectionViewCell {
    
    //----------------------------------------
    // MARK: - View Model Binding
    //----------------------------------------
    
    func bindViewModel(_ viewModel: SongCellViewModel) {
        songView.titleText = viewModel.titleText
    }
    
    //----------------------------------------
    // MARK: - Sizing
    //----------------------------------------
    
    static func sizeThatFits(width: CGFloat) -> CGSize {
        let heightRatio = 304.0 / 130.0
        return CGSize(width: width, height: width / heightRatio)
    }
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    @IBOutlet private var songView: SongView!
}
