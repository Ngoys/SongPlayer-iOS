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

        collectionView.contentInset = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

        collectionView.collectionViewLayout = createCollectionViewLayout()
        collectionView.delegate = self

        statefulPlaceholderView.delegate = self
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
                case .loading:
                    let songs = self.viewModel.fetchAllCoreDataSongs()
                    self.statefulPlaceholderView.isHidden = songs.isEmpty == false
                    self.applySnapshot(songs: songs)

                case .loaded(let songs):
                    self.applySnapshot(songs: songs, animatingDifferences: false)

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

    private func applySnapshot(songs: [Song], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Song>()
        snapshot.appendSections([.main])
        snapshot.appendItems(songs)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    private lazy var dataSource = {
        let dataSource = UICollectionViewDiffableDataSource<Section, Song>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SongCell.self), for: indexPath) as! SongCell
                let viewModel = SongCellViewModel(song: item)
                cell.bindViewModel(viewModel)

                cell.playButtonDidTapSubject
                    .sink { [weak self] _ in
                        guard let self = self else { return }
                        self.viewModel.play(id: item.id)
                    }.store(in: &cell.cancellables)

                cell.pauseButtonDidTapSubject
                    .sink { [weak self] _ in
                        guard let self = self else { return }
                        self.viewModel.pause()
                    }.store(in: &cell.cancellables)

                cell.downloadButtonDidTapSubject
                    .sink { [weak self] _ in
                        guard let self = self else { return }
                        self.viewModel.download(id: item.id)
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
// MARK: - UICollectionViewDelegate
//----------------------------------------

extension SongListViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // No action
    }
}

//----------------------------------------
// MARK:- StatefulViewDelegate
//----------------------------------------

extension SongListViewController: StatefulPlaceholderViewDelegate {

    func statefulPlaceholderViewRetryButtonDidTap(_ statefulPlaceholderView: StatefulPlaceholderView) {
        viewModel.retryInitialLoad()
    }
}
