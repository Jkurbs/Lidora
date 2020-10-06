//
//  MenuViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/7/20.
//

import UIKit
import IGListKit
import SDWebImage
import ChameleonFramework

class MenuViewController: UIViewController {
    
    // MARK: - Properties
    
    var chef = [Chef]() {
        didSet {
            self.adapter.performUpdates(animated: true)
        }
    }
    
    var menus = [Menu]()

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    var imageView = UIImageView()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
        fetchMenu()
        self.curtainController?.moveCurtain(to: .min, animated: false)
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
    
    func setupViews() {
        view.backgroundColor = UIColor.white
        
        let gradientView = UIView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        imageView.addSubview(gradientView)
        

        view.addSubview(collectionView)
        collectionView.backgroundColor = UIColor.clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        adapter.scrollViewDelegate = self 
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height/2),
            
            gradientView.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            gradientView.heightAnchor.constraint(equalTo: imageView.heightAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: -40),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -80),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        let myBlock: SDExternalCompletionBlock! = { [weak self] (image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageUrl: URL?) -> Void in
            guard let self = self else { return }
            if let img = image {
                let color = UIColor(gradientStyle: .topToBottom, withFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height/2), andColors: [UIColor.clear, UIColor(averageColorFrom: img)!])
                gradientView.backgroundColor = color
            }
        }
        imageView.sd_setImage(with: URL(string: chef.first!.thumbnailsURL), placeholderImage: nil, options: .continueInBackground, completed: myBlock)

        
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


// MARK: - ListAdapterDataSource
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
                return CGSize(width: context.containerSize.width, height: 100)
            }
            let sectionController = ListSingleSectionController(cellClass: MenuCell.self, configureBlock: configureBlock, sizeBlock: sizeBlock)
            sectionController.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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
            if let navigationController = curtainController?.curtainViewController as? UINavigationController, let cardViewController = navigationController.topViewController as? CardViewController {
                cardViewController.chef = self.chef.first
                cardViewController.overView.chef = self.chef.first
                cardViewController.cardState = .overview
            }
        }
    }
}

extension MenuViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("SCROLLING: ", scrollView.contentOffset.y)
    }
}
