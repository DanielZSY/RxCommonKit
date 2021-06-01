
import UIKit
import Moya.Swift
import CryptoSwift
import BFKit.Swift
import Result.Swift
import Alamofire.Swift
import HandyJSON.Swift

/// 网络请求库
public struct RxNetworkKit {
    /// 创建一个网络请求管理
    public static var created: RxNetworkKit {
        return RxNetworkKit()
    }
    /// 网络请求对象
    private func defaultAlamofire() -> Alamofire.Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.httpAdditionalHeaders = RxRequestHeaders()
        
        let session = Alamofire.Session.init(configuration: configuration)
        return session
    }
    /// NetworkActivityPlugin插件用来监听网络请求
    private let networkPlugin = NetworkActivityPlugin.init { (changeType, targetType) in
        switch (changeType) {
        case .began:
            BFLog.debug("start network: \(targetType.path)")
        case .ended:
            BFLog.debug("end network: \(targetType.path)")
        }
    }
    /// PluginType插件用来监听网络请求过程
    private let typePlugin = RxNetworkPluginType()
    
    /// 开始请求的方法
    /// - parameter target 接口名称
    /// - parameter responseBlock 请求回调函数
    /// - throws: 异常描述
    /// - returns: 返回值描述
    @discardableResult
    public func request(target: RxNetworkTargetType, completionBlock: @escaping ((_ result: RxNetworkResult) -> (Void))) -> Cancellable {
        
        let headers = target.headers ?? [:]
        let parameters = target.parameters ?? [:]
        let path = target.path
        let provider = MoyaProvider<RxNetworkTargetType>.init(session: self.defaultAlamofire(), plugins: [self.networkPlugin, self.typePlugin], trackInflights: false)
        let task = provider.request(target, progress: nil, completion: { (result) in
            switch result {
            case .success(let response):
                do {
                    let str = RxCryptoKit.aesDecrypt(response.data)
                    BFLog.debug("\n path: \(path) \n headers: \(headers) \n params: \(parameters) \n data: \(str)")
                    guard let model = RxNetworkResult.deserialize(from: str) else {
                        completionBlock(RxNetworkResult.error(message: "errorData".locale))
                        return
                    }
                    switch model.code {
                    case RxNetworkResultCode.unAuthorized.rawValue: NotificationCenter.default.post(name: RxNotificationNameLoginExpired, object: nil)
                    default: break
                    }
                    completionBlock(model)
                } catch {
                    BFLog.debug("\n path: \(path) \n headers: \(headers) \n params: \(parameters) \n  error: \(error.localizedDescription)")
                    completionBlock(RxNetworkResult.error())
                }
            case .failure(let error):
                BFLog.debug("\n path: \(path) \n headers: \(headers) \n params: \(parameters) \n  error: \(error.localizedDescription)")
                completionBlock(RxNetworkResult.error())
            }
        })
        return task
    }
}
