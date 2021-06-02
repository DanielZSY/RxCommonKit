
import UIKit

/// 时间回调通知Key
public let RxNotificationNameExecuteTimer = NSNotification.Name.init(rawValue: "RxNotificationNameExecuteTimer")
/// 全局时间管理器
public class RxTimerKit: NSObject {
    /// 单例模式
    public static let shared = RxTimerKit()
    /// 定时器
    private var timer: Timer?
    /// 当前循环次数
    private var currentCount: Int = 0
    /// 保持心跳频率
    private let pingTime: Int = 10
    
    public override init() {
        super.init()
    }
    deinit {
        self.stopTimer()
    }
    /// 开始定时器
    public final func startTimer() {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.executeTimer), userInfo: nil, repeats: true)
            RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.common)
        }
    }
    /// 停止定时器
    public final func stopTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    /// 执行定时器
    @objc private func executeTimer() {
        self.currentCount += 1
        if (self.currentCount % self.pingTime) == 0 { RxSocketKit.shared.sendPing() }
        NotificationCenter.default.post(name: RxNotificationNameExecuteTimer, object: nil, userInfo: nil)
    }
}
