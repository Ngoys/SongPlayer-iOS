import UIKit

protocol SongListViewControllerDelegate: NSObjectProtocol {

}

class SongListViewController: BaseViewController {

    class func fromStoryboard() -> (UINavigationController, SongListViewController) {
        let navigationController = UIStoryboard(name: "SongList", bundle: nil).instantiateInitialViewController() as! UINavigationController
        let viewController = navigationController.topViewController
        return (navigationController, viewController as! SongListViewController)
    }

    //----------------------------------------
    // MARK:- Section
    //----------------------------------------

    enum Section: Int, Hashable {
        case main
    }

    //----------------------------------------
    // MARK:- View model
    //----------------------------------------

    var viewModel: SongListViewModel!

    //----------------------------------------
    // MARK:- Delegate
    //----------------------------------------

    weak var delegate: SongListViewControllerDelegate?

    //----------------------------------------
    // MARK: - Configure views
    //----------------------------------------

    override func configureViews() {
        collectionView.register(UINib(nibName: String(describing: SongCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SongCell.self))

        collectionView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 16, right: 0)

        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.delegate = self
    }

    //----------------------------------------
    // MARK: - Bind view model
    //----------------------------------------

    override func bindViewModel() {
        viewModel.statePublisher
            .sink { [weak self] state in
                guard let self = self else { return }

                self.statefulPlaceholderView.bind(state)

                switch state {
                case .loaded(let songPresentationModels):
                    self.applySnapshot(songPresentationModels: songPresentationModels)

                default:
                    break
                }
            }.store(in: &cancellables)
    }

    //----------------------------------------
    // MARK: - UICollectionView layout
    //----------------------------------------

    func createCollectionViewLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            var cellSize: CGSize!
            var itemSize: NSCollectionLayoutSize!
            var group: NSCollectionLayoutGroup!
            var item: NSCollectionLayoutItem!
            var section: NSCollectionLayoutSection!
            let containerWidth = layoutEnvironment.container.contentSize.width

            cellSize = SongCell.sizeThatFits(width: containerWidth)
            itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(cellSize.height))
            item = NSCollectionLayoutItem(layoutSize: itemSize)
            group = .vertical(layoutSize: itemSize, subitems: [item])
            section = NSCollectionLayoutSection(group: group)

            return section
        }

        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }

    //----------------------------------------
    // MARK: - UICollectionView data source
    //----------------------------------------

    private func applySnapshot(songPresentationModels: [SongPresentationModel], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SongPresentationModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(songPresentationModels)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private lazy var dataSource = {
        let dataSource = UICollectionViewDiffableDataSource<Section, SongPresentationModel>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SongCell.self), for: indexPath) as! SongCell
                let viewModel = SongCellViewModel(songPresentationModel: item)
                cell.bindViewModel(viewModel)

                cell.playButtonDidTapSubject
                    .sink { [weak self] _ in
                        guard let self = self else { return }
                        self.viewModel.play(id: item.song.id)
                    }.store(in: &cell.cancellables)

                cell.pauseButtonDidTapSubject
                    .sink { [weak self] _ in
                        guard let self = self else { return }
                        self.viewModel.pause()
                    }.store(in: &cell.cancellables)

                cell.downloadButtonDidTapSubject
                    .sink { [weak self] _ in
                        guard let self = self else { return }
                        self.viewModel.download(id: item.song.id)
                    }.store(in: &cell.cancellables)

                return cell
            })
        return dataSource
    }()

    //----------------------------------------
    // MARK: - Outlets
    //----------------------------------------

    @IBOutlet private var statefulPlaceholderView: StatefulPlaceholderView!

    @IBOutlet private var collectionView: UICollectionView!
}

//----------------------------------------
// MARK: - UICollectionView delegate
//----------------------------------------

extension SongListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // No action
    }
}
