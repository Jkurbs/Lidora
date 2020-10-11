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
        let menuViewController = ProfileViewController()
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
            return CGSize(width: width, height: 170)
        } else if index == 1 {
            return CGSize(width: width, height: 80)
        } else {
            return CGSize(width: width, height: 50)
        }
    }

    override func numberOfItems() -> Int {
        4
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let imageCell = collectionContext?.dequeueReusableCell(of: ImageCell.self, for: self, at: index) as? ImageCell else { fatalError() }
            imageCell.chef = chef
            return imageCell
        } else if index == 1 {
            guard let titleCell = collectionContext?.dequeueReusableCell(of: TitleCell.self, for: self, at: index) as? TitleCell else { fatalError() }
            titleCell.descriptionLabel.text = chef?.description
            return titleCell
        } else if index == 2 {
            guard let titleCell = collectionContext?.dequeueReusableCell(of: InfoCell.self, for: self, at: index) as? InfoCell else { fatalError() }
            titleCell.label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            titleCell.label.text = "Schedule"
            return titleCell
        } else {
            guard let titleCell = collectionContext?.dequeueReusableCell(of: TitleCell.self, for: self, at: index) as? TitleCell else { fatalError() }
            titleCell.label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
            titleCell.label.text = "Menu"
            titleCell.separator.isHidden = true
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
            scheduleViewController.providerId = chef?.id
            self.viewController?.navigationController?.pushViewController(scheduleViewController, animated: true)
        }
    }
}
