
import UIKit
import BFKit

public let RxNotificationNameApiRequestStart = Notification.Name.init(rawValue: "ApiRequestStart")
public let RxNotificationNameApiApiRequestSuccess = Notification.Name.init(rawValue: "ApiRequestSuccess")
public let RxNotificationNameApiApiRequestError = Notification.Name.init(rawValue: "ApiRequestError")
public let RxNotificationNameLoginExpired = Notification.Name.init(rawValue: "LoginExpired")

/// 公共Header
internal func RxRequestHeaders() -> [String: String] {
    var headFields = [String: String]()
    headFields["udid"] = RxUserSetting.shared.udid
    headFields["uid"] = RxUserSetting.shared.userId.str
    headFields["token"] = "Bearer " + RxUserSetting.shared.userToken
    return headFields
}
/// 处理公共参数
internal func RxRequestParameter(_ params: [String: Any]?) -> [String: Any] {
    let strTime = Date.time()
    var dicParmas = [String: Any]()
    dicParmas["t"] = strTime
    if let param = params, param.keys.count > 0 {
        do {
            let strParam = try param.json()
            dicParmas["d"] = param
            dicParmas["s"] = (strParam + strTime).md5().lowercased()
            return dicParmas
        } catch {
            BFLog.debug("params sign error: \(error.localizedDescription)")
        }
    }
    dicParmas["d"] = [:]
    dicParmas["s"] = strTime.md5().lowercased()
    return dicParmas
}
/// 网络状态码
public enum RxNetworkResultCode: Int {
    case success = 200
    case unAuthorized = 201
}
