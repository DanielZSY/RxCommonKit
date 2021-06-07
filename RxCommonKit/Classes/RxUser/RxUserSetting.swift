
import UIKit
import BFKit.Swift
import CoreLocation
import CryptoSwift.Swift

fileprivate let kUDIDConfigKey = "kUDIDConfigKey".md5()
fileprivate let kLoginUserInfoKey = "kLoginUserInfoKey".md5()
fileprivate let kLoginApiTokenKey = "kLoginApiTokenKey".md5()
fileprivate let kLoginUserPhotosKey = "kLoginUserPhotosKey".md5()
fileprivate let kLoginUserVideosKey = "kLoginUserVideosKey".md5()
/// 用户设置类
public class RxUserSetting {
    /// 单例模式
    public static let shared = RxUserSetting()
    /// 设备UDID
    public var udid: String {
        var val = RxUserSetting.shared.getConfigParameters(key: kUDIDConfigKey) as? String
        if val == nil || val?.count == 0 {
            val = UIDevice.current.identifierForVendor?.uuidString ?? kRandomId
            RxUserSetting.shared.setConfigParameters(key: kUDIDConfigKey, value: val)
        }
        return val ?? kRandomId
    }
    /// TOKEN
    public var userToken: String {
        if RxUserSetting.shared.apiToken.count == 0 {
            let dic = RxUserSetting.shared.getLoginUserInfo(key: kLoginApiTokenKey)
            RxUserSetting.shared.apiToken = (dic?["token"] as? String) ?? ""
        }
        return RxUserSetting.shared.apiToken
    }
    /// 用户ID
    public var userId: Int64 {
        if let uid = self.dicUser?["userId"] {
            switch uid {
            case is String: return (uid as! String).longLongValue
            case is Int: return Int64(uid as! Int)
            case is Int64: return uid as! Int64
            default: break
            }
        }
        return 0
    }
    /// 用户对象
    public var user: [String: Any] {
        return RxUserSetting.shared.dicUser ?? [String: Any]()
    }
    /// 是否登录
    public var isLogin: Bool {
        return (RxUserSetting.shared.userToken.count > 0)
    }
    /// 用户相册集合
    public var userPhotos: [String] {
        if let array = self.arrayPhotos { return array }
        let dic = RxUserSetting.shared.getConfigParameters(key: kLoginUserPhotosKey) as? [String: Any]
        self.arrayPhotos = dic?["Photos"] as? [String]
        return self.arrayPhotos ?? [String]()
    }
    /// 用户视频秀
    public var userVideos: [String] {
        if let array = self.arrayVideos { return array }
        let dic = RxUserSetting.shared.getConfigParameters(key: kLoginUserVideosKey) as? [String: Any]
        self.arrayVideos = dic?["Videos"] as? [String]
        return self.arrayVideos ?? [String]()
    }
    private var apiToken: String = ""
    private var dicUser: [String: Any]?
    private var arrayPhotos: [String]?
    private var arrayVideos: [String]?
    /// 初始加载用户信息
    public final func reloadUser() {
        if let dic = self.getLoginUserInfo(key: kLoginUserInfoKey) {
            self.dicUser = dic
        }
    }
    /// 更新登录token
    public final func updateToken(token: String) {
        self.apiToken = token
        if token.count > 0 {
            var dic = [String: Any]()
            dic["token"] = token
            dic["time"] = Date().timeIntervalSince1970
            self.setLoginUserInfo(dic: dic, key: kLoginApiTokenKey)
        } else {
            UserDefaults.standard.removeObject(forKey: kLoginApiTokenKey)
        }
    }
    /// 更新用户信息
    public final func updateUser(dic: [String: Any]) {
        self.dicUser = dic
        self.setLoginUserInfo(dic: dic, key: kLoginUserInfoKey)
        BFLog.debug("update user: \(dic ?? [:])")
    }
    /// 更新相册集合
    public final func updatePhotos(array: [String]) {
        self.arrayPhotos = array
        self.setLoginUserInfo(dic: ["Photos": array], key: kLoginUserPhotosKey)
    }
    /// 更新视频秀
    public final func updateVideos(array: [String]) {
        self.arrayVideos = array
        self.setLoginUserInfo(dic: ["Videos": array], key: kLoginUserVideosKey)
    }
    /// 注销登录
    public final func logout() {
        self.apiToken = ""
        self.dicUser = nil
        self.arrayPhotos = nil
        self.arrayVideos = nil
        UserDefaults.standard.removeObject(forKey: kLoginApiTokenKey)
        UserDefaults.standard.removeObject(forKey: kLoginUserInfoKey)
    }
    /// 设置持久性参数
    public final func setConfigParameters(key: String, value: Any) {
        let mdKey = key.md5()
        var dic = [String: Any]()
        if let str = SSKeychain.password(forService: mdKey, account: mdKey),
           let data = str.data(using: String.Encoding.utf8),
           let old = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] {
            old.keys.forEach { (k) in dic[k] = old[k] }
        }
        dic[key] = value
        do {
            let str = try? dic.json()
            let _ = SSKeychain.setPassword(str, forService: mdKey, account: mdKey)
        } catch {
            BFLog.debug("set config error: \(error.localizedDescription)")
        }
    }
    /// 获取持久性参数
    public final func getConfigParameters(key: String) -> Any? {
        let mdKey = key.md5()
        guard let str = SSKeychain.password(forService: mdKey, account: mdKey) else { return nil }
        guard let data = str.data(using: String.Encoding.utf8) else { return nil }
        do {
            guard let dic = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else { return nil }
            return dic[key]
        } catch {
            BFLog.debug("set config error: \(error.localizedDescription)")
        }
        return nil
    }
    /// 删除持久性参数
    public final func delConfigParameters(key: String) {
        let mdKey = key.md5()
        SSKeychain.deletePassword(forService: mdKey, account: mdKey)
    }
    /// 设置登录用户信息
    private final func setLoginUserInfo(dic: [String: Any]?, key: String) -> Bool {
        guard let value = dic else { return false }
        let data = NSKeyedArchiver.archivedData(withRootObject: value)
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: key)
        return defaults.synchronize()
    }
    /// 获取登录用户信息
    private final func getLoginUserInfo(key: String) -> [String: Any]? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        guard let value =  NSKeyedUnarchiver.unarchiveObject(with: data) as? [String: Any] else { return nil }
        return value
    }
}
