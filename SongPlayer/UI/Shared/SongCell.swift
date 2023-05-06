import UIKit

class SongCell: BaseUICollectionViewCell {
    
    //----------------------------------------
    // MARK: - View Model Binding
    //----------------------------------------
    
    func bindViewModel(_ viewModel: SongCellViewModel) {
        songView.titleText = viewModel.titleText

        viewModel.statePublisher
            .sink { [weak self] state in
                guard let self = self else { return }
                self.songView.status = state.status
            }.store(in: &cancellables)
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
