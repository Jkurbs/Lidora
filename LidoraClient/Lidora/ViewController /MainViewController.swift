//
//  MainViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/6/20.
//

import UIKit
import CoreLocation


class MainViewController: UIViewController {
    
    var locationView = LocationView()
    var locationService: LocationService?
    var collectionView: UICollectionView!
    
    var chefs = [Chef]()
    
    enum Section: Int, Hashable, CaseIterable, CustomStringConvertible {
        case chefs
        var description: String {
            switch self {
                case .chefs: return "chefs"
            }
        }
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Chef>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        configureHierarchy()
        configureDataSource()
        
        chefs = [Chef(id: "1", firstName: "Kerby", lastName: "Jean", email: "kerby.jean@hotmail.fr", phone: "7864684596", dob: ["18", "11", "1996"], ssnLast4: "4444", ssn: "44444444444", imageURL: "", thumbnailsURL: [""], description: "", address: Address(city: "Miami", line1: "14212 NE 3RD CT", postalCode: "33161", state: "FL"), ip: "142.233.454", menu: nil), Chef(id: "2", firstName: "Jake", lastName: "Daniel", email: "kerby.jean@hotmail.fr", phone: "7864684596", dob: ["18", "11", "1996"], ssnLast4: "4444", ssn: "44444444444", imageURL: "", thumbnailsURL: [""], description: "", address: Address(city: "Miami", line1: "14212 NE 3RD CT", postalCode: "33161", state: "FL"), ip: "142.233.454", menu: nil), Chef(id: "3", firstName: "Kurbs", lastName: "Daniel", email: "kerby.jean@hotmail.fr", phone: "7864684596", dob: ["18", "11", "1996"], ssnLast4: "4444", ssn: "44444444444", imageURL: "", thumbnailsURL: [""], description: "", address: Address(city: "Miami", line1: "14212 NE 3RD CT", postalCode: "33161", state: "FL"), ip: "142.233.454", menu: nil) ]
        
        applyInitialSnapshots()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        self.curtainController?.moveCurtain(to: .min, animated: false)
    }
    
    
    func setupViews() {
        
        self.title = "Near you"
        view.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)

        
        let menuBarButton = UIBarButtonItem(image: UIImage(named: "setting-24"), style: .done, target: self, action: #selector(goToSettings))
        let orderButton = UIBarButtonItem(image: UIImage(named: "order-25"), style: .done, target: self, action: #selector(goToOrders))
        navigationController?.navigationBar.tintColor = .darkText
        navigationItem.rightBarButtonItems = [menuBarButton, orderButton]
        locationView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(goToLocationVC)))
    }
    
    
    @objc func goToOrders() {
        self.curtainController?.moveCurtain(to: .hide, animated: true)
        let vc = OrdersViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToSettings() {
        self.curtainController?.moveCurtain(to: .hide, animated: true)
        let vc = SettingsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func goToLocationVC() {
        let navigationController = UINavigationController(rootViewController: LocationViewController())
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func configureHierarchy() {
                
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: createLayout())
        collectionView.delegate = self 
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        collectionView.register(ChefCell.self, forCellWithReuseIdentifier: "ChefCell")
        view.addSubview(collectionView)
        view.addSubview(locationView)
        
        NSLayoutConstraint.activate([
            locationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            locationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            locationView.heightAnchor.constraint(equalToConstant: 30),
            
            collectionView.topAnchor.constraint(equalTo: locationView.bottomAnchor, constant: 20),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: 0)
        ])
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
//            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            var section: NSCollectionLayoutSection

            // orthogonal scrolling section of images
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: -50)
            item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: NSCollectionLayoutSpacing.fixed(0), top: NSCollectionLayoutSpacing.fixed(0), trailing: NSCollectionLayoutSpacing.fixed(0), bottom: NSCollectionLayoutSpacing.fixed(0))
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .fractionalWidth(1.0))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 5
            section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 5)
            section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous

            return section
        }
        return  UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
    }
    
    /// - Tag: ArtsDataSource
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Chef>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in
            guard let section = Section(rawValue: indexPath.section) else { fatalError() }
            switch section {
            case .chefs:
                return collectionView.dequeueConfiguredReusableCell(using: self.configuredGridCell(), for: indexPath, item: item)
            }
        }
    }
    
    /// - Tag: CellConfiguration
    func configuredGridCell() -> UICollectionView.CellRegistration<ChefCell, Chef> {
        return UICollectionView.CellRegistration<ChefCell, Chef> { (cell, indexPath, item) in
            cell.chef = item
        }
    }
    
    
    func applyInitialSnapshots() {
        
        // Set the order for our sections
        
        let sections = Section.allCases
        var snapshot = NSDiffableDataSourceSnapshot<Section, Chef>()
        snapshot.appendSections(sections)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        // Image (orthogonal scroller)
        
        var imageSnapshot = NSDiffableDataSourceSectionSnapshot<Chef>()
        imageSnapshot.append(self.chefs)
        dataSource.apply(imageSnapshot, to: .chefs, animatingDifferences: true)
    }
}


extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(MenuViewController(), animated: true)
    }
}
