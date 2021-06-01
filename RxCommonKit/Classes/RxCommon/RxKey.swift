
import UIKit

/// 全局配置主键
public struct RxKey {
    
    public static var shared = RxKey.init()
    
    private var api: [String]?
    private var wss: String = ""
    
    /// appleId
    private var appleId = ""
    /// IM
    private var wssAppId = ""
    /// push
    private var pushAppId = ""
}
extension RxKey {
    /// 第三方ID
    public static let appId = AppId.init()
    /// 第三方ID
    public struct AppId {
        public let appleId      = RxKey.shared.appleId
        public let wssAppId     = RxKey.shared.wssAppId
        public let pushAppId    = RxKey.shared.pushAppId
    }
    /// 配置AppId
    /// - parameter appleId: 苹果应用ID
    /// - parameter wssAppId: 聊天消息应用ID
    /// - parameter pushAppId: 推送平台应用ID
    /// - returns: null
    /// - throws: null
    public func configAppId(appleId: String, wssAppId: String, pushAppId: String) {
        RxKey.shared.appleId    = appleId
        RxKey.shared.wssAppId   = wssAppId
        RxKey.shared.pushAppId  = pushAppId
    }
}
extension RxKey {
    /// service
    public static let service = Service.init()
    /// service
    public struct Service {
        public let api = RxKey.shared.api?.filter({ api in
            if URL.canOpen(api) { return true }
            return false
        }).first
        public let wss = RxKey.shared.wss
    }
    /// 配置service path
    /// - parameter urls: 接口跟路径
    /// - parameter wsss: IM连接路径
    public func configService(api: [String], wss: String) {
        RxKey.shared.api = api
        RxKey.shared.wss = wss
    }
} 
