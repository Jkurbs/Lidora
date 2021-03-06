//
//  OrderInfoSection.swift
//  Lidora
//
//  Created by Kerby Jean on 9/19/20.
//

import UIKit
import IGListKit

class OrderInfoSection: ListSectionController {
    
    private var info: String?
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        if index == 0 {
            return CGSize(width: width, height: 80)
        }
        return CGSize(width: width, height: 30)
    }
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    }
    
    override func numberOfItems() -> Int {
        2
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: HeaderCell.self, for: self, at: index) as? HeaderCell else { fatalError() }
            cell.label.text = info
            cell.label.font = UIFont.systemFont(ofSize: 30)
            cell.label.textAlignment = .center
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(of: HeaderCell.self, for: self, at: index) as? HeaderCell else { fatalError() }
            cell.title = "Your order"
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        self.info = object as? String
    }
}

