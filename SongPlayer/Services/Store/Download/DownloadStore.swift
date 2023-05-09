import Foundation
import Combine

class DownloadStore: BaseStore {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    override init() {
        self.basicDownloadManager = BasicDownloadManager()
        self.chatHistoryDownloadManager = ChatHistoryDownloadManager()
        self.themeDownloadManager = ThemeDownloadManager()
    }

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var downloadingItemsPublisher: AnyPublisher<[DownloadItem], Never> {
        return downloadingItemsSubject.eraseToAnyPublisher()
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func download(contentIdentifier: String, downloadURL: URL, downloadFileFormat: DownloadFileFormat) -> DownloadItem {
        if Reachability.isConnectedToNetwork() == false {
            return DownloadItem(contentIdentifier: contentIdentifier, downloadURL: downloadURL, status: .error(downloadError: .internetDisconnected))
        }
        
        if let downloadItem = downloadingItemsSubject.value.first(where: { $0.contentIdentifier == contentIdentifier }) {
            return downloadItem
        }

        var downloadItem: DownloadItem?
        
        switch downloadFileFormat {
        case .chatHistory:
            downloadItem = chatHistoryDownloadManager.download(contentIdentifier: contentIdentifier, downloadURL: downloadURL, downloadFileFormat: downloadFileFormat)

        case .theme:
            downloadItem = themeDownloadManager.download(contentIdentifier: contentIdentifier, downloadURL: downloadURL, downloadFileFormat: downloadFileFormat)

        default:
            downloadItem = basicDownloadManager.download(contentIdentifier: contentIdentifier, downloadURL: downloadURL, downloadFileFormat: downloadFileFormat)
        }

        guard let downloadItem = downloadItem else {
            return DownloadItem(contentIdentifier: contentIdentifier, downloadURL: downloadURL, status: .error(downloadError: .invalidURL))
        }

        var downloadingItems = downloadingItemsSubject.value
        downloadingItems.append(downloadItem)
        downloadingItemsSubject.send(downloadingItems)

        handleDownloadItemStatusChange(downloadItem: downloadItem)

        return downloadItem
    }

    private func handleDownloadItemStatusChange(downloadItem: DownloadItem) {
        downloadItem.statusSubject
            .sink(receiveValue: { [weak self] status in
                guard let self = self else { return }

                switch status {
                case .downloaded(_), .error(_):
                    // Remove downloaded items and error items
                    self.downloadingItemsSubject.value.removeAll(where: { $0.contentIdentifier == downloadItem.contentIdentifier })

                default:
                    break
                }

            }).store(in: &cancellables)
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let downloadingItemsSubject = CurrentValueSubject<[DownloadItem], Never>([])

    private let basicDownloadManager: BasicDownloadManager

    private let chatHistoryDownloadManager: ChatHistoryDownloadManager

    private let themeDownloadManager: ThemeDownloadManager
}
