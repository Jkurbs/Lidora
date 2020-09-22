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
        navigationController?.navigationBar.tintColor = .white
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        self.curtainController?.moveCurtain(to: .min, animated: false)

        fetchMenu()
    }
    
    func setupViews() {
        
        view.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        collectionView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height - (self.curtainController?.curtain.actualHeight)!)
        adapter.collectionView = collectionView
        adapter.dataSource = self
    }
    
    func fetchMenu() {
        DataService.shared.fetchMenu(id: (chef.first?.id)!) { (menu, error) in
            if let error = error {
                print("Error: ", error)
            } else {
                self.menus.append(menu!)
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
            sectionController.inset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            sectionController.selectionDelegate = self
            return sectionController
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}

// MARK: - ListSingleSectionControllerDelegate
    
extension MenuViewController: ListSingleSectionControllerDelegate {

    func didSelect(_ sectionController: ListSingleSectionController, with object: Any) {
        if let menu = object as? Menu {
            self.curtainController?.moveCurtain(to: .mid, animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("menu"), object: self, userInfo: ["menu": menu])
            if let cardViewController = curtainController?.curtainViewController as? CardViewController {
                cardViewController.chef = self.chef.first
                cardViewController.overView.chef = self.chef.first
                cardViewController.cardState = .overview
            }
        }
    }
}
