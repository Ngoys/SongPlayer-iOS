import XCTest
import Combine
@testable import SongPlayer

class AudioPlayerServiceTest: BaseTest {

    //----------------------------------------
    // MARK: - Properties
    //----------------------------------------

    var audioPlayerService: AudioPlayerService!

    //----------------------------------------
    // MARK: - Setup
    //----------------------------------------

    func setupAudioPlayerService() {
        audioPlayerService = AudioPlayerService()
    }

    override func setUp() {
        super.setUp()
    }

    //----------------------------------------
    // MARK: - Tests
    //----------------------------------------
    
    func testAudioPlayerService() {
        setupAudioPlayerService()
        
        XCTAssert(mockSongs[1].localFilePath != nil)
        
        audioPlayerService.currentAudioContent = mockSongs[1]
        XCTAssert(audioPlayerService.currentTime == 0)
        XCTAssert(audioPlayerService.isPlaying == false)
        XCTAssert(audioPlayerService.isLoading == false)
        
        audioPlayerService.play(seekTime: 0)
        XCTAssert(audioPlayerService.isPlaying == true)
        XCTAssert(audioPlayerService.currentAudioContent != nil)
        
        audioPlayerService.pause()
        XCTAssert(audioPlayerService.isPlaying == false)
        XCTAssert(audioPlayerService.isLoading == false)
        XCTAssert(audioPlayerService.currentAudioContent != nil)
        
        audioPlayerService.reset()
        XCTAssert(audioPlayerService.isPlaying == false)
        XCTAssert(audioPlayerService.isLoading == false)
        XCTAssert(audioPlayerService.currentAudioContent == nil)
    }
}
