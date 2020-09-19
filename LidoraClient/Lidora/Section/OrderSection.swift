//
//  OrderSection.swift
//  Lidora
//
//  Created by Kerby Jean on 9/19/20.
//

import UIKit
import IGListKit

class OrderSection: ListSectionController {
    
    private var menu: Menu?
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        return CGSize(width: width, height: 45)
    }
    
    override init() {
        super.init()
        
    }
    
    override func numberOfItems() -> Int {
        1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: OrderCell.self, for: self, at: index) as? OrderCell else { fatalError() }
        cell.menu = menu
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.menu = object as? Menu
    }
}

