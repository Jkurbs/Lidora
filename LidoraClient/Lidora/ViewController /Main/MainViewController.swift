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
        fetchChefs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .darkText
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.hidesBarsOnSwipe = false
        self.curtainController?.moveCurtain(to: .min, animated: false)
    }
    
    func fetchChefs() {
        self.chefs.removeAll()
        DataService.shared.fetchChefs(id: "cAim5UCNHnXPAvvK0sUa") { (chef, error) in
            if let error = error {
                print("Error: ", error)
            } else {
                DispatchQueue.main.async {
                    self.chefs.append(chef!)
                    self.applyInitialSnapshots()
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
        let locationViewController = LocationViewController()
        locationViewController.title = "Change location"
        locationViewController.currentAddress = locationView.label.text
        let navigationController = UINavigationController(rootViewController: locationViewController)
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func configureHierarchy() {
                
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: createLayout())
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.tertiarySystemBackground
        
        collectionView.register(ChefCell.self, forCellWithReuseIdentifier: "ChefCell")
        collectionView.addSubview(indicator)
        view.addSubview(collectionView)
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
    
    func createLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
//            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            var section: NSCollectionLayoutSection

            // orthogonal scrolling section of images
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(0.9))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 40, leading: 5, bottom: 5, trailing: -50)
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
        let chef = self.chefs[indexPath.row]
        let menuViewController = MenuViewController()
        menuViewController.chef.append(chef)
        self.navigationController?.pushViewController(menuViewController, animated: true)
    }
}
