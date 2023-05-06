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

    var isFeatured: Bool = false {
        didSet {
            // Future expansion
            // Show a banner, to indicate that the song is featured in the news
        }
    }

    var isUserFavourited: Bool = false {
        didSet {
            // Future expansion
            // Show a star icon, to indicate that the song is bookmarked by the user
        }
    }

    var isTop10Song: Bool = false {
        didSet {
            // Future expansion
            // Add a "Top 10" icon, to indicate that the song is in the top 10 right now in the song chart
        }
    }

    //----------------------------------------
    // MARK: - Outlets
    //----------------------------------------

    @IBOutlet private var titleLabel: UILabel!
}
