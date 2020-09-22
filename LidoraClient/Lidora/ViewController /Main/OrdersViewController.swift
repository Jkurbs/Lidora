//
//  OrdersViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/8/20.
//

import UIKit
import IGListKit

class OrdersViewController: UIViewController, ListAdapterDataSource {
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "You haven't ordered nothing yet"
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var orders = [Order]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchOrders()
    }

    func setupViews() {
        self.title = "Orders"
        view.backgroundColor = .white
        view.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    func fetchOrders() {
        DataService.shared.fetchUpcomingOrders { (order, error) in
            if let error = error {
                print("Error: ", error)
            } else {
                self.orders.append(order!)
//                self.adapter.performUpdates(animated: true)
            }
        }
    }
}

extension OrdersViewController {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return orders as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return CardSection()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return emptyLabel
    }
}
