//
//  CardSection.swift
//  Lidora
//
//  Created by Kerby Jean on 9/12/20.
//

import UIKit
import IGListKit

class CardSection: ListSectionController {
    
    private var order: Order?
    var orders = [Menu]()
    
    lazy var adapter: ListAdapter = {
        let adapter = ListAdapter(updater: ListAdapterUpdater(),
                                  viewController: self.viewController)
        adapter.dataSource = self
        return adapter
    }()
    
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        if index == 0 {
            return CGSize(width: width, height: 40)
        } else {
            return CGSize(width: width, height: 400)
        }
    }
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(addToBag(_:)), name: NSNotification.Name("order"), object: nil)
    }
    
    @objc func addToBag(_ notification: Notification) {        
        
        
        
        
        
//        if let userInfo = notification.userInfo {
//            if let order = userInfo["menu"] as? Menu {
////                self.orders.append(order)
//                self.adapter.performUpdates(animated: true)
//            }
//        }
    }
    
    override func numberOfItems() -> Int {
        1
    }
    
    override func cellForItem(at index: Int) -> UICollectionViewCell {
        if index == 0 {
            guard let cell = collectionContext?.dequeueReusableCell(of: InfoCell.self, for: self, at: index) as? InfoCell else { fatalError() }
            cell.label.text = "14212 NE 3RD CT"
            return cell
        } else {
            guard let cell = collectionContext?.dequeueReusableCell(of: EmbeddedCollectionViewCell.self, for: self, at: index) as? EmbeddedCollectionViewCell else { fatalError() }
            cell.collectionView.backgroundColor = .red
            adapter.collectionView = cell.collectionView
            return cell
        }
    }
    
    override func didUpdate(to object: Any) {
        self.order = object as? Order
    }
}


extension CardSection: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return orders as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ListSection()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
