import UIKit
import BFKit
import HandyJSON.Swift
import CryptoSwift.Swift

/// 密钥
fileprivate let key = ("app"+".guan_ce_sen").md5()
/// 加密管理库
public struct RxCryptoKit {
    
    /// AES-128-ECB加密模式
    public static func aesEncrypt(_ str: String) -> String? {
        do {
            let aes = try AES(key: Padding.zeroPadding.add(to: key.bytes, blockSize: 128), blockMode: ECB())
            let encrypted = try aes.encrypt(str.bytes)
            return encrypted.toBase64()
        } catch let error {
            BFLog.debug("error: \(error.localizedDescription)")
        }
        return nil
    }
    /// AES-128-ECB解密模式
    public static func aesDecrypt(_ data: Data) -> String? {
        do {
            let aes = try AES(key: Padding.zeroPadding.add(to: key.bytes, blockSize: 128), blockMode: ECB())
            let decrypted = try data.decrypt(cipher: aes)
            return try decrypted.json()
        } catch let error {
            BFLog.debug("error: \(error.localizedDescription)")
        }
        return nil
    }
}
