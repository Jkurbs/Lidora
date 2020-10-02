//
//  OrdersViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/8/20.
//

import UIKit
import IGListKit

enum OrderType: Int {
    case past = 0
    case upcoming = 1
}

class OrdersViewController: UIViewController, ListAdapterDataSource {
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "There's no orders yet"
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let segmentedControl = UISegmentedControl(items: ["Past Orders", "Upcoming Orders"])
    
    var orders = [Order]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchPastOrders()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

    func setupViews() {
        self.title = "Orders"
        view.backgroundColor = .white
        view.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        
        view.addSubview(segmentedControl)
        segmentedControl.selectedSegmentIndex = OrderType.past.rawValue
        segmentedControl.addTarget(self, action: #selector(switchOrderType(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16.0),
            segmentedControl.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32.0),
            segmentedControl.heightAnchor.constraint(equalToConstant: 45),
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16.0) ,
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
    
    
    func fetchPastOrders() {
        self.orders.removeAll()
        self.adapter.performUpdates(animated: true)
        DataService.shared.fetchPastOrders { (order, error) in
            if let error = error {
                print("Error: ", error)
            } else {
                self.orders.append(order!)
                self.adapter.performUpdates(animated: true)
            }
        }
    }
    
    func fetchUpcomingOrders() {
        self.orders.removeAll()
        self.adapter.performUpdates(animated: true)
        DataService.shared.fetchUpcomingOrders { (order, error) in
            if let error = error {
                print("Error: ", error)
            } else {
                self.orders.append(order!)
                self.adapter.performUpdates(animated: true)
            }
        }
    }

    
    func fetchOrderItems() {
        
    }
    
    @objc func switchOrderType(_ segmentedControl: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            fetchPastOrders()
        } else {
            fetchUpcomingOrders()
        }
    }
}

extension OrdersViewController {
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return orders as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
         return UpcomingOrdersSection()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return emptyLabel
    }
}
