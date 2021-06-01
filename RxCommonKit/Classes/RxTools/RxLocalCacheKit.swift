
import UIKit
import BFKit.Swift
import CryptoSwift.Swift

/// 本地本地缓存文件夹
fileprivate let RxLocalCacheFile = "LocalCacheFile"

/// 本地缓存数据管理
public struct RxLocalCacheKit {
    
    /// 保存数据到本读指定文件路径
    public static func func_setlocaldata(dic: [String: Any], key: String) {
        
        let filePath = RxLocalCacheKit.createLocalDataFolder().appendingPathComponent((RxUserSetting.shared.userId.str).md5()).appendingPathComponent(key.md5()).appendingPathExtension("txt")
        do {
            let json = try dic.json()
            guard let str = RxCryptoKit.aesEncrypt(str: json) else { return }
            let data = try JSONSerialization.data(withJSONObject: str, options: JSONSerialization.WritingOptions.prettyPrinted)
            try data.write(to: filePath)
        } catch {
            BFLog.error("Error Writing file: \(error.localizedDescription)")
        }
    }
    /// 读取本读指定文件路径的数据
    public static func func_getlocaldata(key: String) -> [String: Any]? {
        
        let filePath = RxLocalCacheKit.createLocalDataFolder().appendingPathComponent((RxUserSetting.shared.userId.str).md5()).appendingPathComponent(key.md5()).appendingPathExtension("txt")
        if !FileManager.default.fileExists(atPath: filePath.path) { return nil }
        do {
            let data = try Data.init(contentsOf: filePath)
            let str = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers])
            guard let val = str as? String else { return nil }
            guard let strJson = RxCryptoKit.aesDecrypt(str: val) else { return nil }
            guard let dataJson = strJson.data(using: .utf8) else { return nil }
            return try? JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: Any]
        } catch {
            BFLog.error("Error Writing file: \(error.localizedDescription)")
        }
        return nil
    }
    /// 创建本地数据的文件夹
    fileprivate static func createLocalDataFolder() -> URL {
        let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let folder = cachesDirectory.appendingPathComponent(RxLocalCacheFile)
        if !FileManager.default.fileExists(atPath: folder.path) {
            do {
                try FileManager.default.createDirectory(atPath: folder.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                BFLog.error("error:\(error)")
            }
        }
        return folder
    }
}
