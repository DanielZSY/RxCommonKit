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
    
    private lazy var arrayVersion: [RxModelVersion] = [RxModelVersion]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        BFLog.debug("date: \(Date()) GMT8: \(Date.time())  time: \(Date.date())")
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
}

