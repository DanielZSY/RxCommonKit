import UIKit
import HandyJSON.Swift

/// 请求返回对象处理
public struct RxNetworkResult {
    
    /// 错误码
    public var code: Int = 0
    /// 是否成功
    public var success: Bool = false
    /// 原数据对象 - 集合或字典
    public var data: Any?
    /// 消息文本
    public var message: String = ""
    /// 创建数据对象
    public static func create(data: [String: Any]?) -> RxNetworkResult {
        var result = RxNetworkResult()
        if let dic = data {
            if let code = dic["c"] {
                switch code {
                case is Int64: result.code = Int((code as? Int64) ?? 0)
                case is String: result.code = (code as? String)?.intValue ?? 0
                default:  result.code = (code as? Int) ?? 0
                }
            }
            result.data = dic["d"]
            result.success = (result.code == RxNetworkResultCode.success.rawValue)
            let message = (dic["m"] as? String) ?? ""
            result.message = message
        }
        return result
    }
    /// 创建错误对象
    public static func create(with error: Error) -> RxNetworkResult {
        var result = RxNetworkResult()
        result.message = error.localizedDescription
        return result
    }
    /// 返回数据集合
    public func mapArray<T: RxModelBase>(model: T) -> [T]? {
        guard let array = self.data as? [Any] else { return nil }
        guard let models = [T].deserialize(from: array) else { return nil }
        return models.flatMap { model in return model }
    }
    /// 返回数据对象
    public func mapModel<T: RxModelBase>(model: T) -> T? {
        guard let dic = self.data as? [String: Any] else { return nil }
        return T.deserialize(from: dic)
    }
}
