
import UIKit
import Moya.Swift
import BFKit.Swift

/// 基础请求接口
public enum RxNetworkTargetType {
    /// 请求接口
    case get(String, [String: Any]?)
    /// 请求接口
    case post(String, [String: Any]?)
    /// 上传图片
    case uploadImages(String, [UIImage])
    /// 上传文件
    case uploadFiles(String, [Data], RxEnumImage)
}
/// 基础请求实现
extension RxNetworkTargetType: TargetType {
    
    public var baseURL: URL {
        return URL.init(string: RxKey.service.api)!
    }
    public var path: String {
        switch self {
        case .get(let val, _): return val + "?_v=\(kAppVersion)&_t=ios"
        case .post(let val, _): return val + "?_v=\(kAppVersion)&_t=ios"
        case .uploadImages(let val, _), .uploadFiles(let val, _, _): return val + "?_v=\(kAppVersion)&_t=ios"
        }
    }
    public var parameters: [String: Any]? {
        switch self {
        case .get(_, let params): return RxRequestParameter(params)
        case .post(_, let params): return RxRequestParameter(params)
        default: break
        }
        return nil
    }
    public var method: Moya.Method {
        switch self {
        case .get(_, _): return .get
        default: break
        }
        return .post
    }
    public var task: Task {
        switch self {
        case .uploadImages(_, let images):
            var datas = [MultipartFormData]()
            images.forEach { (image) in
                if let data = image.jpegData(compressionQuality: 0.6) {
                    let provider = MultipartFormData.FormDataProvider.data(data)
                    let fileName = kRandomId
                    let format = MultipartFormData.init(provider: provider, name: "file", fileName: "\(fileName).jpeg", mimeType: "image/jpeg")
                    datas.append(format)
                }
            }
            return .uploadMultipart(datas)
        case .uploadFiles(_, let files, let type):
            var datas = [MultipartFormData]()
            files.forEach { (data) in
                let provider = MultipartFormData.FormDataProvider.data(data)
                let fileName = kRandomId
                var mimetype = "file/" + type.rawValue
                switch type {
                case .jpeg, .png, .jpg: mimetype = "image/" + type.rawValue
                case .mp3, .amr:  mimetype = "audio/" + type.rawValue
                case .mp4, .wav:  mimetype = "video/" + type.rawValue
                }
                let format = MultipartFormData.init(provider: provider, name: "file", fileName: "\(fileName).\(type.rawValue)", mimeType: mimetype)
                datas.append(format)
            }
            return .uploadMultipart(datas)
        case .get(_, _):
            let param = self.parameters ?? [:]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        default: break
        }
        let param = self.parameters ?? [:]
        return .requestParameters(parameters: param, encoding: JSONEncoding.prettyPrinted)
    }
    public var headers: [String: String]? {
        var dic = RxRequestHeaders()
        switch self {
        case .uploadFiles(_, _, _), .uploadImages(_, _):
            dic["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
        default:
            dic["Content-Type"] = "application/json; charset=utf-8"
        }
        return dic
    }
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
}
