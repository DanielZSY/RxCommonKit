
import UIKit
import BFKit
import AVKit
import AVFoundation

/// 播放录制音频代理协议
public protocol RxAudioPlayerDelegate: class {
    func RxAudioPlayerror()
    func audioPlayFinish()
    func audioPlayProgress(currentTime: Float, duration: Float)
}
/// 播放录制音频播放状态
public enum RxAudioPlayerState {
    case playing
    case pause
    case stopped
}
/// 播放录制音频管理类
public class RxAudioPlayerKit: NSObject {
    
    public static let shared = RxAudioPlayerKit()
    public var state: RxAudioPlayerState = .stopped
    public weak var delegate: RxAudioPlayerDelegate?
    
    private var currentTime: Float = 0
    private var totalTime: Float = 1
    private var RxAudioPlayer: AVAudioPlayer?
    private var playerPath: String = ""
    private var progressTimer: Timer?
    
    deinit {
        self.RxAudioPlayer?.stop()
        self.RxAudioPlayer = nil
    }
    public override init() {
        super.init()
    }
    /// 播放声音
    public final func playSound(path: String) {
        let session = AVAudioSession.sharedInstance()
        try? session.setActive(true)
        try? session.setCategory(.playback, mode: .default, options: .defaultToSpeaker)
        self.stopSound()
        self.playerPath = path
        BFLog.debug("start player path: \(self.playerPath)")
        let url = URL.init(fileURLWithPath: path, isDirectory: true)
        BFLog.debug("start player url: \(url.absoluteString)")
        guard let player = try? AVAudioPlayer(contentsOf: url) else {
            self.delegate?.RxAudioPlayerror()
            return
        }
        RxAudioPlayer = player
        RxAudioPlayer?.delegate = self
        RxAudioPlayer?.prepareToPlay()
        RxAudioPlayer?.play()
        state = .playing
        startProgressTimer()
    }
    /// 暂停播放
    public final func pauseSound() {
        RxAudioPlayer?.pause()
        state = .pause
        progressTimer?.invalidate()
        progressTimer = nil
    }
    /// 停止播放
    public final func stopSound() {
        RxAudioPlayer?.stop()
        state = .stopped
        progressTimer?.invalidate()
        progressTimer = nil
        RxAudioPlayer = nil
    }
    /// 播放进度回调
    @objc private func didFireProgressTimer(_ timer: Timer) {
        guard let player = RxAudioPlayer else { return }
        BFLog.debug("audioPlayProgress currentTime: \(player.currentTime), duration: \(player.duration)")
        self.delegate?.audioPlayProgress(currentTime: Float(player.currentTime), duration: Float(player.duration))
    }
    /// 开始执行播放进度
    private func startProgressTimer() {
        progressTimer?.invalidate()
        progressTimer = nil
        progressTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.didFireProgressTimer(_:)), userInfo: nil, repeats: true)
    }
}
extension RxAudioPlayerKit: AVAudioPlayerDelegate {
    
    public func AudioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        stopSound()
        self.delegate?.audioPlayFinish()
        BFLog.debug("AudioPlayerDidFinishPlaying successfully: \(flag)")
    }
    public func AudioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        stopSound()
        self.delegate?.RxAudioPlayerror()
        BFLog.debug("AudioPlayerDecodeErrorDidOccur error: \(error?.localizedDescription)")
    }
}
