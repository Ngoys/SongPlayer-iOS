import Foundation

struct SongPresentationState {
    var status: SongPresentationStatus = .canDownload

    // Future expansion
    // We can add more properties here to govern the state of the SongPresentationModel and change the UI accordingly and easily
    // If one day, designer asked to separate out the "Download" button, I can easily add it here,
    // Then change the UI on SongView
    var isFeatured: Bool = false
    var isUserFavourited: Bool = false
    var isTop10Song: Bool = false
}
