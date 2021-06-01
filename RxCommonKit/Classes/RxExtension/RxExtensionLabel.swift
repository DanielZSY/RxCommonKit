
import UIKit

extension UILabel {
    
    public var fontSize: CGFloat {
        get {
            return self.font.pointSize
        }
        set {
            self.font = UIFont.systemFont(ofSize: newValue)
        }
    }
    public var boldSize: CGFloat {
        get {
            return self.font.pointSize
        }
        set {
            self.font = UIFont.boldSystemFont(ofSize: newValue)
        }
    }
}
extension UIButton {
    
    public var fontSize: CGFloat {
        get {
            return self.titleLabel?.fontSize ?? 18
        }
        set {
            self.titleLabel?.fontSize = newValue
        }
    }
    public var boldSize: CGFloat {
        get {
            return self.titleLabel?.boldSize ?? 18
        }
        set {
            self.titleLabel?.boldSize = newValue
        }
    }
}
