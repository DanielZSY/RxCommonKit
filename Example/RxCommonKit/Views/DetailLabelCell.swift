//
//  DetailLabelCell.swift
//  RxCommonKit_Example
//
//  Created by Daniel on 2021/6/4.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class DetailLabelCell: UICollectionViewCell {
    
    fileprivate let padding: CGFloat = 15.0
    
    lazy private var titleLabel: UILabel = {
        let view = UILabel()
        view.backgroundColor = .clear
        view.textAlignment = .left
        view.font = .systemFont(ofSize: 17)
        view.textColor = .darkText
        self.contentView.addSubview(view)
        return view
    }()
    
    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let frame = contentView.bounds.insetBy(dx: padding, dy: 0)
        titleLabel.frame = frame
    }
}
