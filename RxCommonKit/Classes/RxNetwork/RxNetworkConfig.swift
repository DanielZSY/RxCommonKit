
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
    headFields["Content-Type"] = "application/json"
    return headFields
}
/// 处理公共参数
internal func RxRequestParameter(_ params: [String: Any]?) -> [String: Any] {
    let strTime = Date.time()
    do {
        if let param = params {
            let strParam = (try? param.json()) ?? ""
            var dicParmas = [String: Any]()
            dicParmas["d"] = param
            dicParmas["t"] = strTime
            dicParmas["s"] = (strParam + strTime).md5
            return dicParmas
        }
    } catch {
        BFLog.debug("params sign error: \(error.localizedDescription)")
    }
    var dicParmas = [String: Any]()
    dicParmas["d"] = [String: Any]()
    dicParmas["t"] = strTime
    dicParmas["s"] = (strTime).md5
    return dicParmas
}
/// 网络状态码
public enum RxNetworkResultCode: Int {
    case success = 200
    case unAuthorized = 201
}
