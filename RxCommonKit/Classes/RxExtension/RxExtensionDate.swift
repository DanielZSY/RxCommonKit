
import UIKit

extension Date {
    /// 获取东八区时间
    public static func date() -> Date {
        let time = TimeZone.current.secondsFromGMT()
        return Date().addingTimeInterval(TimeInterval(time))
    }
    /// 获取东八区时间格式
    public static func time(format: String = RxFormat.yyyyMMddHHmmss, locale: String = "zh_CN") -> String {
        return Date().dateString(format: format, locale: locale)
    }
    /// 是否为今天
    public func isToday() -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date.date())
        let selfCmps = calendar.dateComponents(unit, from: self)
        
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (selfCmps.day == nowComps.day)
    }
    /// 是否为昨天
    public func isYesterday() -> Bool {
        let calendar = Calendar.current
        let unit: Set<Calendar.Component> = [.day,.month,.year]
        let nowComps = calendar.dateComponents(unit, from: Date.date())
        let selfCmps = calendar.dateComponents(unit, from: self)
        if selfCmps.day == nil || nowComps.day == nil {
            return false
        }
        let count = nowComps.day! - selfCmps.day!
        return (selfCmps.year == nowComps.year) &&
            (selfCmps.month == nowComps.month) &&
            (count == 1)
    }
    /// 是否为今年
    public func isThisYear() -> Bool {
        let calendar = Calendar.current
        let nowCmps = calendar.dateComponents([.year], from: Date.date())
        let selfCmps = calendar.dateComponents([.year], from: self)
        let result = nowCmps.year == selfCmps.year
        return result
    }
    /// 获得与当前时间的差距
    public func deltaWithNow() -> DateComponents {
        let calendar = Calendar.current
        let cmps = calendar.dateComponents([.hour,.minute,.second], from: self, to: Date.date())
        return cmps
    }
}
