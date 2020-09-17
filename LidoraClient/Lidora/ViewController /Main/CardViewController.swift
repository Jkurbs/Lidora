//
//  CardViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/6/20.
//

import UIKit
import IGListKit
import SweetCurtain

enum CardState: String, CaseIterable {
    case none
    case empty
    case notEmpty
    case overview
}

class CardViewController: UIViewController {
    
    let titleView = TitleView() 
    let emptyView = EmptyView()
    let overView = OverView() 
    var proceedButton = UIButton()
    var user: User?
    var chef: Chef?
    var menus = [Menu]()
    
    var cardState = CardState.empty {
        didSet {
            switch cardState {
            case .empty:
                collectionView.isHidden = true
                emptyView.isHidden = false
                overView.isHidden = true
                proceedButton.isHidden = true
            case .notEmpty:
                emptyView.isHidden = true
                overView.isHidden = true
            case .overview:
                collectionView.isHidden = true
                emptyView.isHidden = true
                overView.isHidden = false
                proceedButton.isHidden = true
            case .none:
                collectionView.isHidden = true
                emptyView.isHidden = true
                overView.isHidden = true
                proceedButton.isHidden = true
            }
        }
    }
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.layer.position.y = 100
        indicator.layer.position.x = view.layer.position.x
        indicator.style = .medium
        indicator.backgroundColor = .red
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchBag()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.clipsToBounds = true
        view.layer.cornerRadius = 10.0
        view.backgroundColor = UIColor.white

        view.addSubview(titleView)
        titleView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        titleView.cardButton.addTarget(self, action: #selector(handleCardButton), for: .touchUpInside)
        
        emptyView.isHidden = false
        overView.isHidden = true
        
        emptyView.updateView(imageName: "bag", title: "There's nothing in your bag")
        view.addSubview(emptyView)
        view.addSubview(overView)
        
        view.addSubview(collectionView)
        collectionView.isHidden = true
        collectionView.backgroundColor = .white
        collectionView.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        view.addSubview(proceedButton)
        proceedButton.translatesAutoresizingMaskIntoConstraints = false
        proceedButton.setTitle("Pre-Order", for: .normal)
        proceedButton.backgroundColor = .systemBlue
        proceedButton.addTarget(self, action: #selector(placeOrder), for: .touchUpInside)

        NSLayoutConstraint.activate([
            emptyView.widthAnchor.constraint(equalTo: view.widthAnchor),
            emptyView.heightAnchor.constraint(equalTo: view.heightAnchor),
            overView.widthAnchor.constraint(equalTo: view.widthAnchor),
            overView.heightAnchor.constraint(equalTo: view.heightAnchor),
            proceedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32.0),
            proceedButton.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32),
            proceedButton.heightAnchor.constraint(equalToConstant: 60.0),
            proceedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(addToBag(_:)), name: .addToBag, object: nil)
    }
    
    // MARK: - Functions
    
    func fetchBag() {
        guard let bagId = user?.bagId else { return }
        DataService.shared.fetchBag(bagId: bagId) { (success, bag, menu, error) in
            if !success! {
                self.cardState = .none
            } else {
                self.cardState = .notEmpty
                self.titleView.cardButton.setTitle("View Bag - \(bag!.quantity!)", for: .normal)
                self.menus.append(menu!)
                self.adapter.performUpdates(animated: true)
                self.adapter.reloadObjects(self.menus)
            }
        }
    }
    
    @objc func addToBag(_ notification: Notification) {
        print("ADD TO BAG")
        self.curtainController?.moveCurtain(to: .min, animated: true)
        guard let bagId = user?.bagId else { return }
        if let userInfo = notification.userInfo {
            if let item = userInfo["item"] as? Menu,
               let quantity = userInfo["quantity"] as? Int,
               let total = userInfo["total"] as? Double {
                self.cardState = .notEmpty
                DataService.shared.addItemToBag(bagId: bagId, item: item, quantity: quantity, total: total) { (success, error) in
                    if !success! {
                        print("Error adding to bag: ", error!)
                    } else {
                        self.fetchBag()
                    }
                }
            }
        }
    }
    
    @objc func handleCardButton() {
        self.collectionView.isHidden = false
        self.curtainController?.moveCurtain(to: .max, animated: true)
    }
    
    @objc func placeOrder() {
        guard let chef = chef else { return }
//        DataService.shared.placeOrder(chef: chef, orders: self.orders) { (success, error) in
//            if let error = error {
//                print("Error: ", error)
//            } else {
//                self.view.showMessage("Order placed", type: .success)
//                self.cardState = .empty
//            }
//        }
    }
}

// MARK: - CurtainDelegate
extension CardViewController: CurtainDelegate {
    
    func curtain(_ curtain: Curtain, didChange heightState: CurtainHeightState) {
        switch heightState {
        case .min:
            view.backgroundColor = UIColor(white: 0.6, alpha: 1.0)
            titleView.backgroundColor = UIColor(white: 0.6, alpha: 1.0)
            collectionView.isHidden = true
            if cardState != .notEmpty {
                cardState = .none
            } else {
                proceedButton.isHidden = true
            }
        case .mid:
            view.backgroundColor = .white
            titleView.backgroundColor = .white
            if cardState != .notEmpty {
                cardState = .empty
            } else {
                collectionView.isHidden = false
                proceedButton.isHidden = false
            }
        case .max:
            view.backgroundColor = .white
            titleView.backgroundColor = .white
            if cardState != .notEmpty {
                cardState = .empty
            } else {
                proceedButton.isHidden = false
            }
        default:
            break
        }
    }
    
    func curtainDidDrag(_ curtain: Curtain) {
        
    }
}

extension CardViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
//        var data = ["1"] as [ListDiffable]
//        data += menus as [ListDiffable]
        return menus as [ListDiffable]
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is Int {
            return CardSection()
        } else {
            let configureBlock = { (item: Any, cell: UICollectionViewCell) in
                guard let cell = cell as? OrderCell, let menu = item as? Menu else { return }
                cell.menu = menu
            }
            let sizeBlock = { (item: Any, context: ListCollectionContext?) -> CGSize in
                guard let context = context else { return .zero }
                return CGSize(width: context.containerSize.width, height: 45)
            }
            let sectionController = ListSingleSectionController(cellClass: OrderCell.self, configureBlock: configureBlock, sizeBlock: sizeBlock)
            sectionController.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            sectionController.selectionDelegate = self
            return sectionController
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}
