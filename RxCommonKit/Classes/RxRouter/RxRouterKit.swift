
import UIKit
import BFKit

/// 路由导航器
public enum RxRoutableVC: RxRoutable {
    
    /// 创建一个VC
    case create(_ class: AnyClass, _ params: [String: Any]? = nil)
    /// VC类名
    public var any: AnyClass {
        switch self {
        case .create(let vc, _): return vc.self
        }
    }
    /// VC参数
    public var params: [String: Any]? {
        switch self {
        case .create(_, let param): return param
        }
    }
}
/// 路由协议
public protocol RxRoutable {
    /// VC类名
    var any: AnyClass { get }
    /// VC参数
    var params: [String: Any]? { get }
}
/// 路由方法协议
public protocol RxRoutableBase {
    /// VC实现参数方法
    static func initWithParams(params: [String: Any]?) -> UIViewController
}
/// 路由协议管理类
public struct RxRouterKit {
    /// 当前显示VC
    public static func getCurrentVC() -> UIViewController? {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        let currentVC = RxRouterKit.getCurrentVC(vc: rootVC)
        return currentVC
    }
    private static func getCurrentVC(vc: UIViewController?) -> UIViewController? {
        var currentVC: UIViewController? = vc
        if let rvc = vc, rvc.isKind(of: UITabBarController.classForCoder()) {
            currentVC = RxRouterKit.getCurrentVC(vc: (rvc as? UITabBarController)?.selectedViewController)
        }
        if let rvc = vc, rvc.isKind(of: UINavigationController.classForCoder()) {
            currentVC = RxRouterKit.getCurrentVC(vc: (rvc as? UINavigationController)?.visibleViewController)
        }
        if let pvc = vc?.presentedViewController {
            currentVC = RxRouterKit.getCurrentVC(vc: pvc)
        }
        return currentVC
    }
    /// 当前PushVC
    public static func getCurrentPushVC() -> UIViewController? {
        let rootVC = UIApplication.shared.keyWindow?.rootViewController
        let currentVC = RxRouterKit.getCurrentPushVC(vc: rootVC)
        return currentVC
    }
    private static func getCurrentPushVC(vc: UIViewController?) -> UIViewController? {
        var currentVC: UIViewController? = vc
        if let rvc = vc, rvc.isKind(of: UITabBarController.classForCoder()) {
            currentVC = RxRouterKit.getCurrentPushVC(vc: (rvc as? UITabBarController)?.selectedViewController)
        }
        if let rvc = vc, rvc.isKind(of: UINavigationController.classForCoder()) {
            currentVC = RxRouterKit.getCurrentPushVC(vc: (rvc as? UINavigationController)?.visibleViewController)
        }
        return currentVC
    }
    /// 路由协议push VC
    public static func push(path: RxRoutable, fromVC: UIViewController? = nil, animated: Bool = true) {
        if let cls = path.any as? RxRoutableBase.Type {
            let toVC = cls.initWithParams(params: path.params)
            toVC.hidesBottomBarWhenPushed = true
            DispatchQueue.DispatchaSync(mainHandler: {
                if fromVC != nil {
                    fromVC?.navigationController?.pushViewController(toVC, animated: animated)
                    return
                }
                RxRouterKit.getCurrentPushVC()?.navigationController?.pushViewController(toVC, animated: animated)
            })
        }
    }
    /// 自定义push VC
    public static func push(toVC: UIViewController, fromVC: UIViewController? = nil, animated: Bool = true) {
        toVC.hidesBottomBarWhenPushed = true
        DispatchQueue.DispatchaSync(mainHandler: {
            if fromVC != nil {
                fromVC?.navigationController?.pushViewController(toVC, animated: animated)
                return
            }
            RxRouterKit.getCurrentPushVC()?.navigationController?.pushViewController(toVC, animated: animated)
        })
    }
    public static func pop(toVC: UIViewController? = nil, fromVC: UIViewController, animated: Bool = true, completion: (()->Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        if let vc = toVC {
            fromVC.navigationController?.popToViewController(vc, animated: animated)
        } else {
            fromVC.navigationController?.popViewController(animated: animated)
        }
        CATransaction.commit()
    }
    public static func popToRoot(fromVC: UIViewController?, animated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        fromVC?.navigationController?.popToRootViewController(animated: animated)
        CATransaction.commit()
    }
    /// 路由协议present VC
    public static func present(path: RxRoutable, fromVC: UIViewController? = nil, animated: Bool = true, completion: (()->Void)? = nil) {
        if let cls = path.any as? RxRoutableBase.Type {
            let toVC = cls.initWithParams(params: path.params)
            DispatchQueue.DispatchaSync(mainHandler: {
                if fromVC != nil {
                    fromVC?.present(toVC, animated: animated , completion: completion)
                    return
                }
                if let pvc = RxRouterKit.getCurrentVC()?.presentedViewController {
                    pvc.present(toVC, animated: animated , completion: completion)
                    return
                }
                RxRouterKit.getCurrentVC()?.present(toVC, animated: animated, completion: completion)
            })
        }
    }
    /// 自定义present VC
    public static func present(toVC: UIViewController, fromVC: UIViewController? = nil, animated: Bool = true, completion: (()->Void)? = nil) {
        DispatchQueue.DispatchaSync(mainHandler: {
            if fromVC != nil {
                fromVC?.present(toVC, animated: animated , completion: completion)
                return
            }
            if let pvc = RxRouterKit.getCurrentVC()?.presentedViewController {
                pvc.present(toVC, animated: animated , completion: completion)
                return
            }
            RxRouterKit.getCurrentVC()?.present(toVC, animated: animated, completion: completion)
        })
    }
    public static func dismiss(fromVC: UIViewController? = nil, animated: Bool = true, completion: (()->Void)? = nil) {
        DispatchQueue.DispatchaSync(mainHandler: {
            if let _ = fromVC?.presentingViewController {
                fromVC?.presentingViewController?.dismiss(animated: animated, completion: completion)
                return
            }
            fromVC?.dismiss(animated: animated, completion: completion)
        })
    }
}
