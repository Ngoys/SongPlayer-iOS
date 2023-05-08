import Foundation

class BasicDownloadManager: BaseDownloadManager {

    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------

    override init() {
        self.downloadQueue = OperationQueue()
        self.downloadQueue.name = "BasicDownloadManager.downloadQueue"
        self.downloadQueue.qualityOfService = .background

//        Uncomment this line to download items 1 by 1
//        self.downloadQueue.maxConcurrentOperationCount = 1
    }
    
    //----------------------------------------
    // MARK: - Actions
    //----------------------------------------

    override func download(contentIdentifier: String, downloadURL: URL, downloadFileFormat: DownloadFileFormat) -> DownloadItem {
        // download task
        let downloadItem = DownloadItem(contentIdentifier: contentIdentifier, downloadURL: downloadURL)

        let downloadOperation = DownloadOperation(urlSession: urlSession, contentIdentifier: contentIdentifier, downloadURL: downloadURL)

        downloadOperation.downloadStatusSubject
            .sink { [weak self] status in
                guard let self = self else { return }

                switch status {
                case .downloaded(let localFilePath):
                    guard let localPathURL = URL(string: localFilePath) else { return }

                    do {
                        let rootFolderURL = try FileManager.default.getDocumentDirectoryFolderURL()
                        let downloadsFolderURL = rootFolderURL.appendingPathComponent("Downloads/BandLab", isDirectory: true)

                        // Create Downloads folder if there is none
                        if FileManager.default.fileExists(atPath: downloadsFolderURL.path) == false {
                            try FileManager.default.createDirectory(
                                at: downloadsFolderURL,
                                withIntermediateDirectories: true
                            )
                        }
//                        BasicDownloadManager - downloadStatusSubject - .downloaded - file:///var/mobile/Containers/Data/Application/3AA62F9B-D595-4B92-B412-F725C55C6C3D/Documents/Downloads/BandLab/3.mp3
                        //need to save Documents/Downloads/BandLab/3.mp3 TODO

                        // Write to file
                        let fileName = "\(downloadItem.contentIdentifier).\(downloadFileFormat)"
                        let fileURL = downloadsFolderURL.appendingPathComponent(fileName)

                        // Replace file from localPathURL to fileURL
                        try? FileManager.default.removeItem(at: fileURL)
                        try FileManager.default.moveItem(at: localPathURL, to: fileURL)

                        let url = URL(string: "Downloads/BandLab")?.appendingPathComponent(fileName)
                        print("BasicDownloadManager - downloadStatusSubject - .downloaded - \(fileURL.absoluteString)")
                        downloadItem.status = .downloaded(localFilePath: fileURL.absoluteString)

                    } catch {
                        switch (error as NSError).code {
                        case 512:
                            downloadOperation.downloadStatusSubject.send(.error(downloadError: .diskNotEnoughSpace))

                        default:
                            downloadOperation.downloadStatusSubject.send(.error(downloadError: .badRequest))
                        }
                    }

                default:
                    downloadItem.status = status
                }
            }.store(in: &cancellables)

        downloadQueue.addOperation(downloadOperation)

        return downloadItem
    }

    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------

    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier!).BasicDownloadManager")
        config.sessionSendsLaunchEvents = true
        config.waitsForConnectivity = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()

    private let downloadQueue: OperationQueue
}

//----------------------------------------
// MARK: - URLSessionDownloadDelegate
//----------------------------------------

extension BasicDownloadManager: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        if let downloadOperation = self.getDownloadOperation(task: downloadTask) {
            let progress = Double(fileOffset) / Double(expectedTotalBytes)
            print("BasicDownloadManager - didResumeAtOffset progress - \(progress)")
            downloadOperation.downloadStatusSubject.send(.downloading(progress: progress))
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let downloadOperation = self.getDownloadOperation(task: downloadTask) {
            let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
            print("BasicDownloadManager - didWriteData progress - \(progress)")
            downloadOperation.downloadStatusSubject.send(.downloading(progress: progress))
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let downloadOperation = self.getDownloadOperation(task: downloadTask) {
            print("BasicDownloadManager - didFinishDownloadingTo - \(location.absoluteString)")
            downloadOperation.downloadStatusSubject.send(.downloaded(localFilePath: location.absoluteString))
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let error = error else { return }

        if let downloadOperation = self.getDownloadOperation(task: task) {
            let nsError = error as NSError
            let downloadError: DownloadError = .badRequest

            print("BasicDownloadManager - didCompleteWithError - \(nsError.code) \(error.localizedDescription)")

            switch nsError.code {
            case -999:
                // -999 means cancel, user's cancel IS NOT .failed
                downloadOperation.downloadStatusSubject.send(.queued)

            case 512:
                downloadOperation.downloadStatusSubject.send(.error(downloadError: .diskNotEnoughSpace))

                // check for no internet error TODO
            default:
                downloadOperation.downloadStatusSubject.send(.error(downloadError: downloadError))
            }
        }
    }

    private func getDownloadOperation(task: URLSessionTask) -> DownloadOperation? {
        return self.downloadQueue.operations.first(where: { operation in
            if let downloadOperation = operation as? DownloadOperation {
                return downloadOperation.task == task
            }
            return false
        }) as? DownloadOperation
    }
}
