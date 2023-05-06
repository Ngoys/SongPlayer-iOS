import Foundation
import Combine

class DownloadStore: BaseStore {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    override init() {
        self.basicDownloadManager = BasicDownloadManager()
        self.zipDownloadManager = ZipDownloadManager()
        self.pdfDownloadManager = PDFDownloadManager()
        self.videoDownloadManager = VideoDownloadManager()
    }

    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    func getDownloadingItem(contentIdentifier: String) -> DownloadItem? {
        return downloadingItemsSubject.value.first(where: { $0.contentIdentifier == contentIdentifier })
    }

    func download(contentIdentifier: String, downloadURL: URL, downloadFileFormat: DownloadFileFormat) -> DownloadItem {
        if let downloadItem = getDownloadingItem(contentIdentifier: contentIdentifier) {
            return downloadItem
        }

        var downloadItem: DownloadItem?
        
        switch downloadFileFormat {
        case .mp3, .jpg, .png:
            downloadItem = basicDownloadManager.download(contentIdentifier: contentIdentifier, downloadURL: downloadURL, downloadFileFormat: downloadFileFormat)

        case .zip:
            downloadItem = zipDownloadManager.download(contentIdentifier: contentIdentifier, downloadURL: downloadURL, downloadFileFormat: downloadFileFormat)

        case .pdf:
            downloadItem = pdfDownloadManager.download(contentIdentifier: contentIdentifier, downloadURL: downloadURL, downloadFileFormat: downloadFileFormat)

        case .mp4:
            downloadItem = videoDownloadManager.download(contentIdentifier: contentIdentifier, downloadURL: downloadURL, downloadFileFormat: downloadFileFormat)
        }

        guard let downloadItem = downloadItem else {
            return DownloadItem(contentIdentifier: contentIdentifier, downloadURL: downloadURL, status: .error(downloadError: .invalidURL))
        }

        var downloadingItems = downloadingItemsSubject.value
        downloadingItems.append(downloadItem)
        downloadingItemsSubject.send(downloadingItems)

        return downloadItem
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private let downloadingItemsSubject = CurrentValueSubject<[DownloadItem], Never>([])

    private let basicDownloadManager: BasicDownloadManager

    private let zipDownloadManager: ZipDownloadManager

    private let pdfDownloadManager: PDFDownloadManager

    private let videoDownloadManager: VideoDownloadManager
}