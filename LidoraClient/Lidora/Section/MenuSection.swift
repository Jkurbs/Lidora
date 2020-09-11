//
//  MenuSection.swift
//  Lidora
//
//  Created by Kerby Jean on 9/11/20.
//

import UIKit
import IGListKit

class MenuSection: ListSectionController {

    private var menu: Menu?
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        let height =  collectionContext!.containerSize.height
        return CGSize(width: width, height: height)
        
    }
    
    override init() {
        super.init()
        print("MENU: ", menu?.description)
    }
    
    override func numberOfItems() -> Int {
        1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let imageCell = collectionContext?.dequeueReusableCell(of: ImageCell.self, for: self, at: index) as? ImageCell else { fatalError() }
        return imageCell
    }
    
    override func didUpdate(to object: Any) {
        self.menu = object as? Menu
    }
}
