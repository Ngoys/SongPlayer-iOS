import Foundation
import Combine

protocol AudioPlayer: AnyObject {
    var audioPlayerStateDidChangePublisher: AnyPublisher<AudioPlayer?, Never> { get }
    var currentAudioContent: AudioContent? { get set }
    var isPlaying: Bool { get }
    var isLoading: Bool { get }
    var playbackRate: Float { get set }
    
    func play(seek: Double?)
    func pause(forceDispose: Bool)
    func reset()
}
