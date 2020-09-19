//
//  CardSection.swift
//  Lidora
//
//  Created by Kerby Jean on 9/12/20.
//

import UIKit
import IGListKit

class CardSection: ListSectionController {
    
    private var card: Card?
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        if index == 0 {
            return CGSize(width: width, height: 30)
        } else {
            return CGSize(width: width, height: 60)
        }
    }
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)

    }
    
    override func numberOfItems() -> Int {
        2
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: HeaderCell.self, for: self, at: index) as? HeaderCell else { fatalError() }
            cell.title = "Payment method"
            return cell 
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(of: PrimaryCardCell.self, for: self, at: index) as? PrimaryCardCell else { fatalError() }
            cell.label.text = "*\(card!.last4!)"
            guard let brand = card?.brand else { return UICollectionViewCell() }
            cell.imageView.image = UIImage(named: brand.rawValue)
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        self.card = object as? Card
    }
}

