//
//  MenuViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/7/20.
//

import UIKit
import IGListKit

class MenuViewController: UIViewController {
    
    var chef = [Chef]() {
        didSet {
            self.adapter.performUpdates(animated: true)
        }
    }
    
    var menus = [Menu]()

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        
        fetchMenu()
    }
    
    func setupViews() {
        
        view.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        collectionView.frame = view.frame
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    func fetchMenu() {
        DataService.shared.fetchMenu(id: (chef.first?.id)!) { (menu, error) in
            if let error = error {
                print("Error: ", error)
            } else {
                self.menus.append(menu!)
                print("MENU:: ", self.menus.count)
                self.adapter.performUpdates(animated: true, completion: nil)
            }
        }
    }
}

extension MenuViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var data = chef as [ListDiffable]
        data += menus as [ListDiffable]
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Chef {
            return ChefSection()
        } else {
            let configureBlock = { (item: Any, cell: UICollectionViewCell) in
                guard let cell = cell as? MenuCell, let menu = item as? Menu else { return }
                cell.menu = menu
            }
            let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
                guard let context = context else { return .zero }
                return CGSize(width: context.containerSize.width, height: 90)
            }
            let sectionController = ListSingleSectionController(cellClass: MenuCell.self, configureBlock: configureBlock, sizeBlock: sizeBlock)
            return sectionController
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
