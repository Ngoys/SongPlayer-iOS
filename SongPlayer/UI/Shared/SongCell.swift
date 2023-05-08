import UIKit
import Combine

class SongCell: BaseUICollectionViewCell {
    
    //----------------------------------------
    // MARK: - View Model Binding
    //----------------------------------------
    
    func bindViewModel(_ viewModel: SongCellViewModel) {
        songView.titleText = viewModel.titleText

        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                self.songView.status = state.status
            }.store(in: &cancellables)

        songView.playButtonDidTapSubject
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.playButtonDidTapSubject.send(())
            }.store(in: &cancellables)

        songView.pauseButtonDidTapSubject
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.pauseButtonDidTapSubject.send(())
            }.store(in: &cancellables)

        songView.downloadButtonDidTapSubject
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.downloadButtonDidTapSubject.send(())
            }.store(in: &cancellables)
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    let playButtonDidTapSubject = PassthroughSubject<Void, Never>()

    let pauseButtonDidTapSubject = PassthroughSubject<Void, Never>()

    let downloadButtonDidTapSubject = PassthroughSubject<Void, Never>()

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
