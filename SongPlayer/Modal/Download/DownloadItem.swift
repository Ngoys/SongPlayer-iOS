import Foundation
import Combine

class DownloadItem {
    
    //----------------------------------------
    // MARK: - Initialization
    //----------------------------------------
    
    init(contentIdentifier: String, downloadURL: URL, status: DownloadStatus = .queued) {
        self.contentIdentifier = contentIdentifier
        self.downloadURL = downloadURL
        self.startDate = Date()
        self.statusSubject = CurrentValueSubject<DownloadStatus, Never>(status)
        
        self.statusSubject
            .sink(receiveValue: { [weak self] status in
                guard let self = self else { return }
                
                switch status {
                case .downloaded(_):
                    self.finishedDate = Date()
                    
                default:
                    break
                }
                
            }).store(in: &cancellables)
    }
    
    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------
    
    let contentIdentifier: String
    let downloadURL: URL
    let startDate: Date
    let statusSubject: CurrentValueSubject<DownloadStatus, Never>
    private(set) var finishedDate: Date?
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private var cancellables: Set<AnyCancellable> = Set()
}
