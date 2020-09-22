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
    var proceedButton = LoadingButton()
    var user: User?
    var chef: Chef?
    var order = [Order]()
    var menus = [Menu]()
    var card = [Card]()
    
    var cardState = CardState.empty {
        didSet {
            switch cardState {
            case .empty:
                emptyView.isHidden = false
                self.titleView.cardButton.setTitle("View Bag", for: .normal)
                collectionView.isHidden = true
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
        
        self.navigationController?.isNavigationBarHidden = true
        fetchBag()
        fetchPrimaryCard()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Functions
    
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
        collectionView.frame = CGRect(x: 0, y: 60, width: view.frame.width, height: view.frame.height)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        view.addSubview(proceedButton)
        proceedButton.enable()
        proceedButton.translatesAutoresizingMaskIntoConstraints = false
        proceedButton.setTitle("Place Order", for: .normal)
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

        NotificationCenter.default.addObserver(self, selector: #selector(addToOrder(_:)), name: .addToBag, object: nil)
    }
    
    // MARK: - Functions

    func fetchBag() {
        guard let orderId = user?.orderId else { return }
        DataService.shared.fetchCurrentOrder(orderId: orderId) { (success, order, menu, error) in
            if !success! {
                self.cardState = .none
            } else {
                self.cardState = .notEmpty
                self.titleView.cardButton.setTitle("View Bag - \(order!.quantity!)", for: .normal)
                self.order.append(order!)
                self.menus.append(menu!)
                self.adapter.performUpdates(animated: true)
                self.adapter.reloadObjects(self.menus)
                self.adapter.reloadObjects(self.order)

            }
        }
    }
    
    func fetchPrimaryCard() {
        guard let primaryCardId = user?.primaryCard else { return }
        DataService.shared.fetchPrimaryPaymentMethod(cardId: primaryCardId) { (card, error) in
            if let error = error {
                print("Error getting payment methods: ", error)
            } else {
                self.card.append(card!)
                DispatchQueue.main.async {
                    self.adapter.performUpdates(animated: true)
                }
            }
        }
    }
    
    @objc func addToOrder(_ notification: Notification) {
        self.cardState = .notEmpty
        self.curtainController?.moveCurtain(to: .min, animated: true)
        guard let chef = chef else { return }
        guard let bagId = user?.orderId else { return }
        if let userInfo = notification.userInfo {
            if let item = userInfo["item"] as? Menu,
               let quantity = userInfo["quantity"] as? Int,
               let total = userInfo["total"] as? Double {
                DataService.shared.addItemToOrder(orderId: bagId, chef: chef, item: item, quantity: quantity, total: total) { (success, error) in
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
        self.proceedButton.showLoading()
        guard let order = self.order.first, let card = self.card.first else { return }
        DataService.shared.placeOrder(order: order, card: card) { (success, error) in
            if let _ = error {
                self.proceedButton.hideLoading()
            } else {
                self.view.showMessage("Order placed", type: .success)
                self.cardState = .empty
                self.proceedButton.hideLoading()
            }
        }
    }
}

// MARK: - CurtainDelegate
extension CardViewController: CurtainDelegate {
    
    func curtain(_ curtain: Curtain, didChange heightState: CurtainHeightState) {
        
        if cardState == .overview {
            switch heightState {
            case .min:
                view.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
                titleView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
                titleView.cardButton.setTitleColor(.white, for: .normal)
                emptyView.isHidden = true
                overView.isHidden = true
                cardState = .notEmpty
            case .mid:
                overView.isHidden = false
                print("")
            case .max:
                overView.isHidden = false
               print("")
            default:
                break
            }
        }

        if cardState == .notEmpty {
            switch heightState {
            case .min:
                view.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
                titleView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
                titleView.cardButton.setTitleColor(.white, for: .normal)
                emptyView.isHidden = true
                collectionView.isHidden = true
                proceedButton.isHidden = true
            case .mid:
                view.backgroundColor = .white
                titleView.cardButton.setTitleColor(.darkText, for: .normal)
                collectionView.isHidden = false
                proceedButton.isHidden = false
            case .max:
                titleView.backgroundColor = .white
                titleView.cardButton.setTitleColor(.darkText, for: .normal)
                collectionView.isHidden = false
                proceedButton.isHidden = false
            default:
                break
            }
        } else {
            switch heightState {
            case .min:
                view.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
                titleView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
                titleView.cardButton.setTitleColor(.white, for: .normal)
                emptyView.isHidden = true
                collectionView.isHidden = true
                proceedButton.isHidden = true
            case .mid:
                view.backgroundColor = .white
                titleView.backgroundColor = .white
                emptyView.isHidden = false
                collectionView.isHidden = true
                proceedButton.isHidden = true
            case .max:
                titleView.backgroundColor = .white
                view.backgroundColor = .white
                emptyView.isHidden = false
                collectionView.isHidden = true
                proceedButton.isHidden = true
            default:
                break
            }
        }
    }
    
    func curtainDidDrag(_ curtain: Curtain) {
        
    }
}

// MARK: - ListAdapterDataSource
extension CardViewController: ListAdapterDataSource {
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        var data = ["1"] as [ListDiffable]
        data += menus as [ListDiffable]
        data += card as [ListDiffable]
        data += order as [ListDiffable]
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is String {
            return OrderInfoSection() 
        } else if object is Menu {
            return OrderSection()
        } else if object is Card {
            return CardSection()
        } else {
            return TotalSection()
        }
    }
    
    func emptyView(for listAdapter: ListAdapter) -> UIView? {
        return nil
    }
}


// MARK: - CardDelegate
extension CardViewController: CardDelegate {
    
    func switchCard(newCard: Card) {
        self.card.removeAll()
        self.card.append(newCard)
        self.adapter.performUpdates(animated: true)
        self.adapter.reloadObjects(self.card)
    }
}
