import UIKit

protocol StatefulPlaceholderViewDelegate: AnyObject {
    func statefulPlaceholderViewRetryButtonDidTap(_ statefulPlaceholderView: StatefulPlaceholderView)
}

class StatefulPlaceholderView: UIView {
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
        let view = UINib(nibName: String(describing: StatefulPlaceholderView.self), bundle: nil).instantiate(withOwner: self, options: nil)[0] as! UIView
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        backgroundColor = .clear

        retryButton.layer.cornerRadius = 8
        retryButton.layer.borderWidth = 1
        retryButton.layer.borderColor = UIColor.darkGray.cgColor
    }

    //----------------------------------------
    // MARK: - View bindings
    //----------------------------------------

    func bind<T>(_ state: State<T>) {
        switch state {
        case .loading:
            isHidden = false
            loadingIndicatorView.isHidden = false
            loadingIndicatorView.startAnimating()
            
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            retryButton.isHidden = true
            
        case .loadingFailed(let error):
            isHidden = false
            loadingIndicatorView.isHidden = true
            loadingIndicatorView.stopAnimating()
            
            titleLabel.isHidden = false
            subtitleLabel.isHidden = false
            retryButton.isHidden = false
            
            // Update view based on error.
            let error = error as? AppError
            switch error {
            case .network:
                titleLabel.text = "error.offline.title".localized
                subtitleLabel.text = "error.offline.message".localized

            default:
                titleLabel.text = "error.something_went_wrong".localized
                subtitleLabel.text = "error.please_try_again_later".localized
            }
            
        case .retryingLoad:
            isHidden = false
            loadingIndicatorView.isHidden = false
            loadingIndicatorView.startAnimating()
            
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            retryButton.isHidden = true
            
        case .loaded:
            isHidden = true
            loadingIndicatorView.isHidden = true
            loadingIndicatorView.stopAnimating()
            
            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            retryButton.isHidden = true
        
        case .manualReloading:
            isHidden = true
            loadingIndicatorView.isHidden = true
            loadingIndicatorView.stopAnimating()

            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            retryButton.isHidden = true
            
        case .manualReloadingFailed(_, let error):
            isHidden = true
            loadingIndicatorView.isHidden = true
            loadingIndicatorView.stopAnimating()

            titleLabel.isHidden = true
            subtitleLabel.isHidden = true
            retryButton.isHidden = true
            
        case .loadingNextPage:
            isHidden = true
            loadingIndicatorView.isHidden = true
            loadingIndicatorView.stopAnimating()
        }
    }
    
    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------
    
    @IBAction func retryButtonDidTap(_ sender: UIButton) {
        delegate?.statefulPlaceholderViewRetryButtonDidTap(self)
    }
    
    func showLoadingAnimation() {
        isHidden = false
        loadingIndicatorView.isHidden = false
        loadingIndicatorView.startAnimating()
        
        titleLabel.isHidden = true
        subtitleLabel.isHidden = true
        retryButton.isHidden = true
    }
    
    func hideLoadingAnimation() {
        isHidden = true
        loadingIndicatorView.isHidden = true
        loadingIndicatorView.stopAnimating()
        
        titleLabel.isHidden = true
        subtitleLabel.isHidden = true
        retryButton.isHidden = true
    }
    
    //----------------------------------------
    // MARK: - Delegate
    //----------------------------------------

    weak var delegate: StatefulPlaceholderViewDelegate?
    
    //----------------------------------------
    // MARK: - Outlets
    //----------------------------------------
    
    @IBOutlet private var titleLabel: UILabel!
    
    @IBOutlet private var subtitleLabel: UILabel!

    @IBOutlet private var retryButton: UIButton!

    @IBOutlet private var loadingIndicatorView: UIActivityIndicatorView!
}
