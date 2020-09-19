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
        return CGSize(width: width, height: 30)
    }
    
    override init() {
        super.init()
        
    }
    
    override func numberOfItems() -> Int {
        1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: HeaderCell.self, for: self, at: index) as? HeaderCell else { fatalError() }
        cell.title = "Your order"
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.info = object as? String
    }
}

