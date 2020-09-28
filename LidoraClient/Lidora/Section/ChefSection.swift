//
//  ChefSection.swift
//  Lidora
//
//  Created by Kerby Jean on 9/10/20.
//

import UIKit
import IGListKit

class ChefSection: ListSectionController {

    private var chef: Chef? {
        didSet {
            guard let menu = chef?.menu else { return }
            menus.append(menu)
        }
    }
    
    var menus = [Menu]()
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        if index == 0 {
            return CGSize(width: width, height: 200)
        } else if index == 1 {
            return CGSize(width: width, height: 100)
        } else  {
            return CGSize(width: width, height: 50)
        }
    }

    override func numberOfItems() -> Int {
        2
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let imageCell = collectionContext?.dequeueReusableCell(of: ImageCell.self, for: self, at: index) as? ImageCell else { fatalError() }
            imageCell.imageURL = chef?.imageURL
            return imageCell
        } else {
            guard let titleCell = collectionContext?.dequeueReusableCell(of: TitleCell.self, for: self, at: index) as? TitleCell else { fatalError() }
            titleCell.chef = chef
            return titleCell
        }
    }
    
    override func didUpdate(to object: Any) {
        self.chef = object as? Chef
    }
    
    override func didSelectItem(at index: Int) {
        if index == 2 {
            self.viewController?.curtainController?.moveCurtain(to: .hide, animated: false)
            let scheduleViewController = ScheduleViewController()
            self.viewController?.navigationController?.pushViewController(scheduleViewController, animated: true)
        }
    }
}
