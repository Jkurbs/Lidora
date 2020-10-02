//
//  MainViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/6/20.
//

import UIKit
import IGListKit

class MainViewController: UIViewController {
    
    var locationView = LocationView()
    var locationService: LocationService?
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    var collectionView: UICollectionView!
    
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.layer.position.y = 100
        indicator.layer.position.x = view.layer.position.x
        indicator.style = .medium
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var chefs = [Chef]()
    var user: User? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        fetchChefs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .darkText
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.hidesBarsOnSwipe = false
        self.curtainController?.moveCurtain(to: .min, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    
    func fetchChefs() {
        self.chefs.removeAll()
        DataService.shared.fetchChefs() { (chef, error) in
            if let error = error {
                print("Error: ", error)
            } else {
                DispatchQueue.main.async {
                    self.chefs.append(chef!)
                    self.adapter.performUpdates(animated: true)
                    self.indicator.stopAnimating()
                    
                }
            }
        }
    }
    
    
    func setupViews() {
        view.backgroundColor = UIColor.tertiarySystemBackground
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "setting-24"), style: .done, target: self, action: #selector(goToSettings))
        let orderButton = UIBarButtonItem(image: UIImage(named: "order-25"), style: .done, target: self, action: #selector(goToOrders))
        
        navigationController?.navigationBar.tintColor = .darkText
        navigationItem.rightBarButtonItems = [menuBarButton, orderButton]
        locationView.label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToLocationVC)))
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.tertiarySystemBackground
        collectionView.isScrollEnabled = true
//        collectionView.scro
        collectionView.addSubview(indicator)
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
                
        self.locationView.updateViews("\(user?.line1 ?? "") \(user?.postalCode ?? "")")

        view.addSubview(locationView)
        
        NSLayoutConstraint.activate([
            locationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -40),
            locationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            locationView.heightAnchor.constraint(equalToConstant: 90),
            collectionView.topAnchor.constraint(equalTo: locationView.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0)
        ])
    }
    
    @objc func goToOrders() {
        self.curtainController?.moveCurtain(to: .hide, animated: true)
        let vc = OrdersViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToSettings() {
        self.curtainController?.moveCurtain(to: .hide, animated: true)
        let vc = SettingsViewController()
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToLocationVC() {
        let locationViewController = LocationViewController()
        locationViewController.title = "Change Location"
        locationViewController.delegate = self
        locationViewController.locationType = .update
        locationViewController.currentAddress = locationView.label.text
        let navigationController = UINavigationController(rootViewController: locationViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
}


// MARK: - LocationDelegate
extension MainViewController: LocationDelegate {
    
    func location(line1: String, postalCode: String, city: String, state: String) {
        self.locationView.updateViews("\(line1) \(postalCode)")
    }
}


extension MainViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return chefs as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ChefAroundSection()
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
