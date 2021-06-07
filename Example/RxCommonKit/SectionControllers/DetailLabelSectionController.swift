//
//  LabelSectionController.swift
//  RxCommonKit_Example
//
//  Created by Daniel on 2021/6/4.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit
import IGListKit

class DetailLabelSectionController: ListSectionController {
    
    var onDidSelectItem: ((_ row: Int) -> Void)?
    
    private var object: String?
    
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: collectionContext!.containerSize.width, height: 55)
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: DetailLabelCell.self, for: self, at: index) as? DetailLabelCell else {
            fatalError()
        }
        cell.title = object
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.object = String(describing: object)
    }
    
    override func didSelectItem(at index: Int) {
        self.onDidSelectItem?(self.section)
    }
}
