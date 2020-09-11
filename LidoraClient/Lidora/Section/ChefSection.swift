//
//  ChefSection.swift
//  Lidora
//
//  Created by Kerby Jean on 9/10/20.
//

import UIKit
import IGListKit

class ChefSection: ListSectionController, ListAdapterDataSource {

    private var chef: Chef? {
        didSet {
            guard let menu = chef?.menu else { return }
            print("Menu: ", menu.description)
            menus.append(menu)
            adapter.performUpdates(animated: true)
        }
    }
    
    var menus = [Menu]()
    
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                  viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        if index == 0 {
            return CGSize(width: width, height: 200)
        } else if index == 1 {
            return CGSize(width: width, height: 80)
        } else  {
            return CGSize(width: width, height: 50)
        }
    }
    
    override init() {
        super.init()
        self.inset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    
    override func numberOfItems() -> Int {
        3
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let imageCell = collectionContext?.dequeueReusableCell(of: ImageCell.self, for: self, at: index) as? ImageCell else { fatalError() }
            imageCell.imageURL = chef?.imageURL
            return imageCell
        } else if index == 1 {
            guard let titleCell = collectionContext?.dequeueReusableCell(of: TitleCell.self, for: self, at: index) as? TitleCell else { fatalError() }
            titleCell.chef = chef
            return titleCell
        } else if index == 2 {
            guard let infoCell = collectionContext?.dequeueReusableCell(of: InfoCell.self, for: self, at: index) as? InfoCell else { fatalError() }
            return infoCell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(of: EmbeddedCollectionViewCell.self, for: self, at: index) as? EmbeddedCollectionViewCell else { fatalError() }
            adapter.collectionView = cell.collectionView
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        self.chef = object as? Chef
    }
}

extension ChefSection {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return menus as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return MenuSection()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
