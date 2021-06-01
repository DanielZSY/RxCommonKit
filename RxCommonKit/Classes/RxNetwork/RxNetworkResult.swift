import UIKit
import HandyJSON.Swift

/// 请求返回对象处理
public struct RxNetworkResult: HandyJSON {
    
    /// 错误码
    public var code: Int = 0
    /// 数据 - 集合或字典
    public var data: Any?
    /// 错误消息
    public var message: String = ""
    /// 时间
    public var time: TimeInterval = 0
    /// 签名
    public var sign: String = ""
    
    public init() {
        
    }
    public mutating func mapping(mapper: HelpingMapper) {
        
        mapper <<< self.code <-- "c"
        mapper <<< self.data <-- "d"
        mapper <<< self.message <-- "m"
        mapper <<< self.time <-- "t"
        mapper <<< self.sign <-- "s"
    }
    /// 创建错误对象
    public static func error(message: String = "errorNetwork".locale) -> RxNetworkResult {
        var result = RxNetworkResult()
        result.message = message
        return result
    }
    /// 是否成功
    public func isSuccess() -> Bool {
        return self.code == RxNetworkResultCode.success.rawValue
    }
    /// 返回数据集合
    public func mapArray<T: RxModelBase>(type: T.Type) -> [T]? {
        guard let array = self.data as? [Any] else { return nil }
        guard let models = [T].deserialize(from: array) else { return nil }
        return models.flatMap { model in return model }
    }
    /// 返回数据对象
    public func mapModel<T: RxModelBase>(type: T.Type) -> T? {
        guard let dic = self.data as? [String: Any] else { return nil }
        return T.deserialize(from: dic)
    }
}
