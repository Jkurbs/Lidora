//
//  ChefSection.swift
//  Lidora
//
//  Created by Kerby Jean on 9/10/20.
//

import UIKit
import IGListKit

class ChefAroundSection: ListSectionController {

    private var chef: Chef?
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 50, left: 16, bottom: 20, right: 16)
    }
    
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width - 100
        return CGSize(width: width, height: width + 50)
    }

    override func numberOfItems() -> Int {
        1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let chefCell = collectionContext?.dequeueReusableCell(of: ChefCell.self, for: self, at: index) as? ChefCell else { fatalError() }
        chefCell.chef = chef
        return chefCell
    }
    
    override func didUpdate(to object: Any) {
        self.chef = object as? Chef
    }
    
    override func didSelectItem(at index: Int) {
        let menuViewController = MenuViewController()
        menuViewController.chef.append(chef!)
        self.viewController?.navigationController?.pushViewController(menuViewController, animated: true)
    }
}


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
            imageCell.imageURL = chef?.thumbnailsURL
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
