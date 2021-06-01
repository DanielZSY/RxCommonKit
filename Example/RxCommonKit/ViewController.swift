//
//  ViewController.swift
//  RxCommonKit
//
//  Created by XuanCheng on 05/27/2021.
//  Copyright (c) 2021 XuanCheng. All rights reserved.
//

import UIKit
import BFKit
import RxCommonKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BFLog.debug("date: \(Date()) GMT8: \(Date.GMT8())  time: \(Date.time())")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}

