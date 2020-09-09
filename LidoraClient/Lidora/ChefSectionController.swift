//
//  ChefSectionController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/7/20.
//

import IGListKit

class ChefSectionController: ListSectionController {
    
    private var chef: Chef?
    
    override func sizeForItem(at index: Int) -> CGSize {
        
        let width = collectionContext!.containerSize.width
        let infoHeight: CGFloat = 150
        
        if index == 0 {
            return CGSize(width: width, height: 430)
        } else {
            return CGSize(width: width, height: infoHeight)
        }
    }
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    
    override func numberOfItems() -> Int {
        2
    }
    
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: ChefCell.self, for: self, at: index) as? ChefCell else {
                       fatalError()
            }
        return cell 
    }
    
    override func didUpdate(to object: Any) {
        self.chef = object as? Chef
    }
}
