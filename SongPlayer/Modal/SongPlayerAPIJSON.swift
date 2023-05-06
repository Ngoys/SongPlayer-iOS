import Foundation

struct SongPlayerAPIJSON<T>: Decodable where T: Decodable {
    let data: T
}
