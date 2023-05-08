import Foundation
import Combine

protocol AudioPlayer: AnyObject {
    var audioPlayerStateDidChangePublisher: AnyPublisher<AudioPlayer?, Never> { get }
    var currentAudioContent: AudioContent? { get set }
    var isPlaying: Bool { get }
    var isLoading: Bool { get }
    var currentTime: TimeInterval { get set }
    
    func play(seekTime: Double?)
    func pause(forceDispose: Bool)
    func reset()
}
