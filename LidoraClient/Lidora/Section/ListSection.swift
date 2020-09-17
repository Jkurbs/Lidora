//
//  ListSection.swift
//  Lidora
//
//  Created by Kerby Jean on 9/14/20.
//

import UIKit
import IGListKit

class ListSection: ListSectionController {

    private var order: Order?
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        return CGSize(width: width, height: 60.0)
    }
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }
    
    override func numberOfItems() -> Int {
        1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: OrderCell.self, for: self, at: index) as? OrderCell else { fatalError() }
//        cell.order = order
        return cell
    }
    
    override func didUpdate(to object: Any) {
        self.order = object as? Order
    }
}
