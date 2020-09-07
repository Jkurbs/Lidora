//
//  MainViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/6/20.
//

import UIKit

class MainViewController: UIViewController {
    
    var locationView = LocationView()
    var collectionView: UICollectionView!
    
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
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = true 
        self.title = "Near you"
    }
    
    func configureHierarchy() {
        
        let toolbarHeight = navigationController!.toolbar.frame.size.height
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - toolbarHeight), collectionViewLayout: createLayout())
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        locationView.frame = CGRect(x: 0, y: 30, width: view.frame.width, height: 10)
        collectionView.addSubview(locationView)
    }
    
    func createLayout() -> UICollectionViewLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
//            guard let sectionKind = Section(rawValue: sectionIndex) else { return nil }
            let section: NSCollectionLayoutSection
            
            let width = self.view.frame.width
            let height = self.collectionView.frame.height - 75
            
            // orthogonal scrolling section of images
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(height))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(width), heightDimension: .absolute(height))
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                                
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
                return  UICollectionViewCell()
                //collectionView.dequeueConfiguredReusableCell(using: self.configuredGridCell(), for: indexPath, item: item)
            }
        }
    }
}
