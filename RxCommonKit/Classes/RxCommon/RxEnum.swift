
import UIKit
import GRDB.Swift
import HandyJSON.Swift

/// 状态类型
public enum RxEnumStatus: Int, HandyJSONEnum, DatabaseValueConvertible {
    /// 无
    case none = 0
    /// 开发中
    case dev = 1
    /// 发布中
    case release = 2
    /// 运营中
    case normal = 3
}
/// 文件类型
public enum RxEnumImage: String {
    /// 图片
    case png = "png"
    /// 图片
    case jpeg = "jpeg"
    /// 图片
    case jpg = "jpg"
    /// 音频
    case mp3 = "mp3"
    /// 音频
    case amr = "amr"
    /// 视频
    case mp4 = "mp4"
    /// 视频
    case wav = "wav"
}
/// bool类型
public enum RxEnumBool: String {
    /// 真
    case yes = "y"
    /// 假
    case no = "n"
}
