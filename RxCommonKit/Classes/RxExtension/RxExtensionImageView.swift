
import UIKit
import BFKit
import AlamofireImage

extension UIImageView {
    
    private struct AssociatedKey {
        static var viewUrl = "viewUrl"
        static var viewActivityIndicator = "viewActivityIndicator"
    }
    public var currentPath: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.viewUrl) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.viewUrl, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    private var aiView: UIActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKey.viewActivityIndicator) as? UIActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKey.viewActivityIndicator, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    /// 下载一张网络图片
    public func setImage(strPath: String, placeholder: UIImage?, style: UIActivityIndicatorView.Style = .gray) {
        
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        if strPath.count == 0 {
            self.image = placeholder
            return
        }
        guard let url = URL.init(string: strPath) else { return }
        self.currentPath = strPath
        if self.aiView == nil {
            self.aiView = UIActivityIndicatorView.init(style: style)
            self.addSubview(self.aiView!)
            self.bringSubviewToFront( self.aiView!)
        }
        self.aiView?.size = CGSize.init(width: 20, height: 20)
        self.aiView?.center = CGPoint.init(x: self.width/2, y: self.height/2)
        self.aiView?.startAnimating()
        let cacheKey = url.absoluteString.md5()
        self.af.setImage(withURL: url, cacheKey: cacheKey, placeholderImage: placeholder, imageTransition: .crossDissolve(0.25), completion: { [weak self] response in
            guard let `self` = self else { return }
            self.aiView?.stopAnimating()
            switch response.result {
            case .success(let img): self.image = img
            case .failure(let error): BFLog.debug("download image error: \(error.localizedDescription)")
            }
        })
    }
}
