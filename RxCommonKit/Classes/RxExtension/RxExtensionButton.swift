
import UIKit

extension UIButton {
    /// 文本内容
    public var text: String? {
        get {
            return self.titleLabel?.text
        }
        set {
            self.setTitle(newValue, for: .normal)
            self.setTitle(newValue, for: .highlighted)
        }
    }
    /// 文本颜色
    public var textColor: UIColor? {
        get {
            return self.titleLabel?.textColor
        }
        set {
            self.setTitleColor(newValue, for: .normal)
            self.setTitleColor(newValue, for: .highlighted)
        }
    }
    /// 默认状态背景图片
    public var backgroundImageNormal: UIImage? {
        get {
            return self.backgroundImage(for: .normal)
        }
        set {
            self.setBackgroundImage(newValue, for: .normal)
            self.setBackgroundImage(newValue, for: .highlighted)
        }
    }
    /// 禁用状态背景图片
    public var backgroundImageDisabled: UIImage? {
        get {
            return self.backgroundImage(for: .disabled)
        }
        set {
            self.setBackgroundImage(newValue, for: .disabled)
        }
    }
    /// 选择状态背景图片
    public var backgroundImageSelect: UIImage? {
        get {
            return self.backgroundImage(for: .selected)
        }
        set {
            self.setBackgroundImage(newValue, for: .selected)
        }
    }
}
