//
//  UpcomingOrdersSection.swift
//  Lidora
//
//  Created by Kerby Jean on 9/24/20.
//

import UIKit
import IGListKit

class UpcomingOrdersSection: ListSectionController {
    
    private var order: Order?
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        return CGSize(width: width, height: 150)
    }
    
    override func numberOfItems() -> Int {
        1
    }
    
    
    
    func loadOrderItems() {
        
    }
    
    
    
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: UpcomingOrderCell.self, for: self, at: index) as? UpcomingOrderCell else { fatalError() }
        cell.order = order
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.order = object as? Order
    }
}

