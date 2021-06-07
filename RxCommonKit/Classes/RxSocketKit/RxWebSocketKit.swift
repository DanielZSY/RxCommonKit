
import UIKit
import BFKit.Swift
import HandyJSON.Swift
import Starscream.Swift

/// IM收到消息通知
public let RxNotificationNameSocketContent = Notification.Name.init(rawValue: "RxNotificationNameSocketContent")
/// IM状态管理
public final class RxWebSocketKit: NSObject {
    /// 单例模式
    public static let shared = RxWebSocketKit()
    /// 连接状态
    public var is_connected: Bool { return self.isConnected }
    /// IM聊天
    private var webSocket: WebSocket?
    /// 连接状态
    private var isConnected: Bool = false
    /// 心跳数据
    private var pingData: String {
        var data = RxModelWssHeartBeat()
        data.userId = RxUserSetting.shared.userId.str
        var model = RxModelWssRequest()
        model.seq = kRandomId
        model.cmd = "heartbeat"
        model.data = data.toDictionary()
        return (try? model.toDictionary().json()) ?? ""
    }
    /// 登录数据
    private var loginData: String {
        var data = RxModelWssLogin()
        data.userId = RxUserSetting.shared.userId.str
        var model = RxModelWssRequest()
        model.seq = kRandomId
        model.cmd = "login"
        model.data = data.toDictionary()
        return (try? model.toDictionary().json()) ?? ""
    }
    /// 检查服务
    private var checkData: String {
        var model = RxModelWssRequest()
        model.seq = kRandomId
        model.cmd = "ping"
        model.data = [String: Any]()
        return (try? model.toDictionary().json()) ?? ""
    }
    /// 开始连接
    public final func reconnect() {
        if self.isConnected || !RxUserSetting.shared.isLogin { return }
        let url = URL.init(string: RxKey.service.wss)!
        var request = URLRequest.init(url: url)
        request.timeoutInterval = 10
        let uid = RxUserSetting.shared.userId.str
        let token = RxUserSetting.shared.userToken
        request.setValue(uid, forHTTPHeaderField: "uid")
        request.setValue(token, forHTTPHeaderField: "token")
        request.setValue("13", forHTTPHeaderField: "Sec-WebSocket-Version")
        self.webSocket = WebSocket.init(request: request)
        self.webSocket?.delegate = self
        self.webSocket?.connect()
        BFLog.debug("reconnect")
    }
    /// 断开连接
    public final func disconnect() {
        self.webSocket?.disconnect()
        self.webSocket?.delegate = nil
        self.webSocket = nil
        self.isConnected = false
        BFLog.debug("disconnect")
    }
    /// 保持心跳
    public final func sendPing() {
        if !RxUserSetting.shared.isLogin { return }
        if !self.isConnected {
            self.reconnect()
            return
        }
        BFLog.debug("pingData: \(self.pingData)")
        self.webSocket?.write(string: self.pingData, completion: {
            BFLog.debug("message send completion")
        })
        self.webSocket?.write(ping: ".".dataValue!, completion: {
            BFLog.debug("message ping completion")
        })
        self.webSocket?.write(string: self.checkData, completion: {
            BFLog.debug("message check completion")
        })
    }
    /// 发送登录
    private final func sendLogin() {
        BFLog.debug("loginData: \(self.loginData)")
        self.webSocket?.write(string: self.loginData, completion: {
            BFLog.debug("message login completion")
        })
    }
}
extension RxWebSocketKit: WebSocketDelegate {
    /// WS回调事件
    public func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            self.isConnected = true
            BFLog.debug("websocket is connected: \(headers)")
            self.sendLogin()
        case .disconnected(let reason, let code):
            self.isConnected = false
            BFLog.debug("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let text):
            BFLog.debug("websocket Received message: \(text)")
            guard let model = RxModelWssHead.deserialize(from: text) else { return }
            switch model.cmd {
            //case "exit": // 退出频道
            //case "enter": // 进入房间
            case "heartbeat": // 心跳
                self.isConnected = model.response.code == 200
                self.reconnect()
            case "ping":
                self.isConnected = model.response.code == 200
                self.reconnect()
            case "msg":
                let message = model.response
                NotificationCenter.default.post(name: RxNotificationNameSocketContent, object: message, userInfo: nil)
            default: break
            }
        case .binary(let data):
            BFLog.debug("websocket binary data: \(data.count)")
        case .ping(let data):
            BFLog.debug("websocket ping data: \(data?.count ?? 0)")
        case .pong(let data):
            BFLog.debug("websocket pong data: \(data?.count ?? 0)")
        case .viabilityChanged(_):
            self.isConnected = false
            BFLog.debug("websocket viabilityChanged")
        case .reconnectSuggested(_):
            BFLog.debug("websocket reconnectSuggested")
        case .cancelled:
            self.isConnected = false
            BFLog.debug("websocket cancelled")
        case .error(let error):
            self.isConnected = false
            BFLog.debug("websocket error: \(error?.localizedDescription ?? "")")
        }
    }
}
