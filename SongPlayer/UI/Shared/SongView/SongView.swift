import UIKit

class SongView: UIView {
    
    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    override init(frame: CGRect) {
        super.init(frame: frame)

        sharedInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        sharedInit()
    }

    private func sharedInit() {
        let view = UINib(nibName: String(describing: SongView.self), bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView

        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        let constraints = [
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var titleText: String? {
        didSet {
            titleLabel.text = titleText
        }
    }
    
    var status: SongPresentationStatus? {
        didSet {
            //            switch status {
            //            case .canPlay
            //            case .canPause:
            //            case .canDownload:
            //            case .isDownloading(let progress):
            //            }
        }
    }
    
    //----------------------------------------
    // MARK: - Outlets
    //----------------------------------------

    @IBOutlet private var titleLabel: UILabel!
}
