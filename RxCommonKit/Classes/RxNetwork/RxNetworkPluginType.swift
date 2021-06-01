
import UIKit
import Foundation
import Moya.Swift
import BFKit.Swift
import Result.Swift
import Alamofire.Swift

/// 网络请求插件类型
public class RxNetworkPluginType: PluginType {
    
    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        return request
    }
    public func willSend(_ request: RequestType, target: TargetType) {
        NotificationCenter.default.post(name: RxNotificationNameApiRequestStart, object: target.path)
    }
    public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let data):
            NotificationCenter.default.post(name: RxNotificationNameApiApiRequestSuccess, object: data)
        case .failure(let error):
            NotificationCenter.default.post(name: RxNotificationNameApiApiRequestError, object: error.localizedDescription)
        default: break
        }
    }
}
