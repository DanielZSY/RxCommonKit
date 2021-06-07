
import UIKit
import BFKit.Swift
import HandyJSON.Swift
import Starscream.Swift

/// IM收到消息通知
public let RxNotificationNameSocketContent = Notification.Name.init(rawValue: "RxNotificationNameSocketContent")
/// IM状态管理
public final class RxSocketKit: NSObject {
    /// 单例模式
    public static let shared = RxSocketKit()
    /// 连接状态
    public var is_connected: Bool { return self.isConnected }
    /// IM聊天
    private var webSocket: WebSocket?
    /// 连接状态
    private var isConnected: Bool = false
    /// 心跳默认数据
    private var pingData: String = "."
    /// 是否收到上次的回执Ping
    private var isReceiptPing: Bool = true
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
    /// 发送消息
    public final func sendMessage(model: RxModelMessage) {
        self.webSocket?.write(string: model.messageContent, completion: {
            BFLog.debug("message send completion")
        })
    }
    /// 保持心跳
    public final func sendPing() {
        if !self.isReceiptPing { self.isConnected = false }
        self.reconnect()
        if let data = self.pingData.dataValue {
            self.isReceiptPing = false
            self.webSocket?.write(ping: data, completion: {
                BFLog.debug("ping send completion")
            })
        }
        self.sendMessage()
    }
    /// 发送默认消息
    private final func sendMessage() {
        self.webSocket?.write(string: self.pingData, completion: {
            BFLog.debug("message send completion")
        })
    }
}
extension RxSocketKit: WebSocketDelegate {
    /// WS回调事件
    public func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            self.isConnected = true
            self.isReceiptPing = true
            BFLog.debug("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            self.isConnected = false
            BFLog.debug("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let text):
            BFLog.debug("websocket Received text: \(text)")
            NotificationCenter.default.post(name: RxNotificationNameSocketContent, object: text, userInfo: RxUserSetting.shared.user)
        case .binary(let data):
            BFLog.debug("websocket binary data: \(data.count)")
        case .ping(let data):
            BFLog.debug("websocket ping data: \(data?.count ?? 0)")
        case .pong(let data):
            self.isReceiptPing = data?.count == self.pingData.count
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
