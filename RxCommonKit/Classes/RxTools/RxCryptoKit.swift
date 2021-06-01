import UIKit
import BFKit
import CryptoSwift

/// 密钥
fileprivate let key = ("app"+".guan_ce_sen").md5()
/// 加密管理库
public struct RxCryptoKit {
    
    /// AES-128-ECB加密模式
    public static func aesEncrypt(_ str: String) -> String {
        do {
            // 使用AES-128-ECB加密模式
            let aes = try AES(key: Padding.zeroPadding.add(to: key.bytes, blockSize: 128), blockMode: ECB())
            // 开始加密
            let encrypted = try aes.encrypt(str.bytes)
            // 将加密结果转成base64形式
            guard let encryptedBase64 = encrypted.toBase64() else { return str }
            return encryptedBase64
        } catch let error {
            BFLog.debug("error: \(error.localizedDescription)")
        }
        return str
    }
    /// AES-128-ECB解密模式
    public static func aesDecrypt(_ data: Data) -> String {
        do {
            // 使用AES-128-ECB加密模式
            let aes = try AES(key: Padding.zeroPadding.add(to: key.bytes, blockSize: 128), blockMode: ECB())
            // 开始解密（从加密后的base64字符串解密）
            let decrypted = try data.base64EncodedString().decryptBase64ToString(cipher: aes)
            return decrypted
        } catch let error {
            BFLog.debug("error: \(error.localizedDescription)")
        }
        return data.base64EncodedString()
    }
}
