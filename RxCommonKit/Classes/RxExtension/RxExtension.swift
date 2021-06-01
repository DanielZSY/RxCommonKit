
import UIKit
import BFKit
import AVKit

extension CGFloat {
    public var scale: CGFloat {
        return self * kScreenScale
    }
    public var str: String {
        return String(format: "%.f", self)
    }
    public var strDouble: String {
        return String(format: "%.2f", self)
    }
}
extension Int {
    public var scale: CGFloat {
        return CGFloat(self) * kScreenScale
    }
    public var str: String {
        return String(self)
    }
}
extension Double {
    public var scale: CGFloat {
        return CGFloat(self) * kScreenScale
    }
    public var str: String {
        return String(format: "%.f", self)
    }
    public var strDouble: String {
        return String(format: "%.2f", self)
    }
}
extension Int32 {
    public var str: String {
        return String(self)
    }
}
extension Int64 {
    public var str: String {
        return String(self)
    }
}
extension Float {
    public var str: String {
        return String(format: "%.f", self)
    }
    public var strDouble: String {
        return String(format: "%.2f", self)
    }
}
extension UInt32 {
    public static func random(lower: UInt32 = min, upper: UInt32 = max) -> UInt32 {
        var m: UInt32
        let u = upper - lower
        var r = arc4random()
        if u > UInt32(UInt32.max) {
            m = 1 + ~u
        } else {
            m = ((max - (u * 2)) + 1) % u
        }
        while r < m {
            r = arc4random()
        }
        return (r % u) + lower
    }
    public var str: String {
        return String(self)
    }
}
extension Error {
    public var code: Int {
        return (self as NSError).code
    }
    public var domain: String {
        return (self as NSError).domain
    }
}
extension TimeInterval {
    /// 秒转换成倒计时格式 00:00:00
    public var strTime: String {
        let allTime: Int = Int(self)
        var hours = 0
        var minutes = 0
        var seconds = 0
        var hoursText = ""
        var minutesText = ""
        var secondsText = ""
        
        hours = allTime / 3600
        hoursText = hours > 9 ? "\(hours)" : "0\(hours)"
        
        minutes = allTime % 3600 / 60
        minutesText = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        
        seconds = allTime % 3600 % 60
        secondsText = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        if hoursText == "00" {
            return "\(minutesText):\(secondsText)"
        }
        return "\(hoursText):\(minutesText):\(secondsText)"
    }
    /// 获取默认年月日时分秒时间格式
    public var strFormatTime: String {
        if self == 0 { return "" }
        let date = Date.date()
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = RxFormat.yyyyMMddHHmmss
        dfmatter.locale = Locale.current
        return dfmatter.string(from: date)
    }
    /// 时间戳转换成指定时间格式 - 默认年月日时分秒
    public func strFormatTime(format: String = RxFormat.yyyyMMddHHmmss) -> String {
        if self == 0 { return "" }
        let date = Date.date()
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = format
        dfmatter.locale = Locale.current
        return dfmatter.string(from: date)
    }
}
extension Int64 {
    /// 秒转换成倒计时格式 00:00:00
    public var strTime: String {
        return TimeInterval(self).strTime
    }
}
extension Float {
    /// 秒转换成倒计时格式 00:00:00
    public var strTime: String {
        return TimeInterval(self).strTime
    }
}
extension Int {
    /// 秒转换成倒计时格式 00:00:00
    public var strTime: String {
        return TimeInterval(self).strTime
    }
}
extension AVPlayerItem {
    private struct AssociatedKey {
        static var viewTag = "viewTag"
    }
    public var tag: Int {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKey.viewTag) as? Int else {
                return 0
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.viewTag, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
extension AVAudioPlayer {
    private struct AssociatedKey {
        static var viewTag = "viewTag"
    }
    public var tag: Int {
        get {
            guard let value = objc_getAssociatedObject(self, &AssociatedKey.viewTag) as? Int else {
                return 0
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.viewTag, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
