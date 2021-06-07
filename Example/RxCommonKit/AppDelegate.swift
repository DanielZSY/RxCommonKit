//
//  AppDelegate.swift
//  RxCommonKit
//
//  Created by XuanCheng on 05/27/2021.
//  Copyright (c) 2021 XuanCheng. All rights reserved.
//

import UIKit
import BFKit
import RxCommonKit
@_exported import RxCocoa
@_exported import RxSwift
@_exported import IGListKit
@_exported import IGListDiffKit
@_exported import RxIGListKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        BFLog.active = true
        BFLog.debug("date: \(Date()) GMT8: \(Date.time())  time: \(Date.date())")
        RxKey.shared.configService(api: ["http://im.91vh.com"], wss: "ws://192.168.0.38:8089/acc")
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = UINavigationController.init(rootViewController: HomeViewController())
        self.becomeFirstResponder()
        return true
    }
}

