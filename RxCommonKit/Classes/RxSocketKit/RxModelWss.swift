
import UIKit
import HandyJSON.Swift

public protocol RxModelWssDictionary {
    
    mutating func toDictionary() -> [String: Any]
}
extension RxModelWssDictionary {
    mutating public func toDictionary() -> [String: Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label: String?, value: Any) -> (String, Any)? in
            guard let label = label else { return nil }
            return (label, value)
        }).compactMap { $0 })
        return dict
    }
}
/// IM登录
public struct RxModelWssLogin: HandyJSON, RxModelWssDictionary {
    public var userId: String
    public var appId: Int
    
    public init() {
        self.userId = ""
        self.appId = 101
    }
    public func mapping(mapper: HelpingMapper) {
        
    }
}
/// IM发送数据
public struct RxModelWssRequest: HandyJSON, RxModelWssDictionary {
    public var seq: String
    public var cmd: String
    public var data: [String: Any]
    
    public init() {
        self.seq = ""
        self.cmd = ""
        self.data = [String: Any]()
    }
    public func mapping(mapper: HelpingMapper) {
        
    }
}
/// IM发送心跳
public struct RxModelWssHeartBeat: HandyJSON, RxModelWssDictionary {
    public var userId: String
    
    public init() {
        self.userId = ""
    }
    public func mapping(mapper: HelpingMapper) {
        
    }
}
/// IM返回命令
public struct RxModelWssHead: HandyJSON, RxModelWssDictionary {
    public var seq: String
    public var cmd: String
    public var response: RxModelWssResponse
    
    public init() {
        self.seq = ""
        self.cmd = ""
        self.response = RxModelWssResponse()
    }
    public func mapping(mapper: HelpingMapper) {
        
    }
}
/// IM返回数据
public struct RxModelWssResponse: HandyJSON, RxModelWssDictionary {
    public var code: Int
    public var codeMsg: String
    public var data: Any?
    
    public init() {
        self.code = 0
        self.codeMsg = ""
    }
    public func mapping(mapper: HelpingMapper) {
        
    }
}
