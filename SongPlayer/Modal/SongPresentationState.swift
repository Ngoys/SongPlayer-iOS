import Foundation

struct SongPresentationState {
    var status: SongPresentationStatus = .canDownload

    // Future expansion
    // We can add more properties here to govern the state of the SongPresentationModel and change the UI accordingly and easily
    var isFeatured: Bool = false
    var isUserFavourited: Bool = false
    var isTop10Song: Bool = false
}
