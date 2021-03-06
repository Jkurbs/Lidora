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
    
    let emptyView = EmptyView()
    let overView = OverView()
    var proceedView = ProceedView()
    
    var titleViewLabel = UILabel()
    
    var user: User?
    var chef: Chef?
    
    var orderDetails = [String]()
    var order = [Order]()
    var menus = [Menu]()
    var card = [Card]()
    
    var cancelButton: UIBarButtonItem!
    
    var cardState = CardState.empty {
        didSet {
            switch cardState {
            case .empty:
                self.titleViewLabel.text = "View Bag"
                emptyView.isHidden = false
                collectionView.isHidden = true
                proceedView.isHidden = true
            case .notEmpty:
                emptyView.isHidden = true
                overView.isHidden = true
            case .overview:
                self.titleViewLabel.text = nil
                collectionView.isHidden = true
                emptyView.isHidden = true
                overView.isHidden = false
                proceedView.isHidden = true
            case .none:
                collectionView.isHidden = true
                emptyView.isHidden = true
                overView.isHidden = true
                proceedView.isHidden = true
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
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Functions
    
    func setupViews() {
        view.backgroundColor = UIColor.white

        navigationController?.view.layer.cornerRadius = 15
        self.navigationController?.navigationBar.tintColor = .systemGreen
        
        titleViewLabel.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleViewLabel.center.x = view.center.x
        titleViewLabel.textAlignment = .center
        titleViewLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        titleViewLabel.isUserInteractionEnabled = true
        titleViewLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCardButton)))
        titleViewLabel.text = "View Bag"
        navigationItem.titleView = titleViewLabel
        
        cardState = .none
        
        cancelButton = UIBarButtonItem(title: "Dismiss", style: .done, target: self, action:  #selector(cancel))
        
        emptyView.isHidden = false
        overView.isHidden = true
        
        emptyView.updateView(imageName: "bag", title: "There's nothing in your bag")
        view.addSubview(emptyView)
        view.addSubview(overView)
        
        view.addSubview(collectionView)
        collectionView.isHidden = true
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        view.addSubview(proceedView)
        proceedView.clearButton.addTarget(self, action: #selector(clearOrder), for: .touchUpInside)
        proceedView.proceedButton.addTarget(self, action: #selector(placeOrder), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            emptyView.widthAnchor.constraint(equalTo: view.widthAnchor),
            emptyView.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200.0),
            
            overView.widthAnchor.constraint(equalTo: view.widthAnchor),
            overView.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            proceedView.widthAnchor.constraint(equalTo: view.widthAnchor),
            proceedView.heightAnchor.constraint(equalToConstant: 200.0),
            proceedView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            proceedView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(addToOrder(_:)), name: .addToBag, object: nil)
    }
    
    // MARK: - Functions
    
    func fetchOrder() {
        guard let orderId = user?.orderId else { return }
        self.order.removeAll()
        self.menus.removeAll()
        DataService.shared.fetchCurrentOrder(orderId: orderId) { (success, order, menu, error) in
            if !success! {
                self.cardState = .none
            } else {
                self.titleViewLabel.text = "View Bag - \(order!.quantity!)"
                self.overView.order = order
                self.cardState = .notEmpty
                self.orderDetails.append(order!.providerName)
                self.order.append(order!)
                self.menus.append(menu!)
                self.adapter.performUpdates(animated: true)
                self.adapter.reloadObjects(self.menus)
                self.adapter.reloadObjects(self.order)
            }
        }
    }
    
    @objc func clearOrder() {
        self.proceedView.clearButton.showLoading()
        guard let orderId = self.order.first?.id else { return }
        clearBagAlert(orderId: orderId)
    }
    
    func fetchData() {
        self.user = nil
        DataService.shared.fetchUser() { (user, error) in
            if let user = user {
                self.user = user
                self.fetchOrder()
                self.fetchPrimaryCard()
            }
        }
    }
    
    func fetchPrimaryCard() {
        self.card.removeAll()
        guard let primaryCardId = user?.primaryCard else { return }
        DataService.shared.fetchPrimaryPaymentMethod(cardId: primaryCardId) { (card, error) in
            if let error = error {
                print("Error getting payment methods: ", error)
            } else {
                self.card.append(card!)
                self.adapter.performUpdates(animated: true)
                self.adapter.reloadObjects(self.card)
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
                        self.fetchOrder()
                    }
                }
            }
        }
    }
    
    @objc func handleCardButton() {
        self.fetchData()
        self.curtainController?.moveCurtain(to: .max, animated: true)
    }
    
    @objc func placeOrder() {
        self.proceedView.proceedButton.showLoading()
        guard let order = self.order.first, let card = self.card.first else {
            addCardAlert()
            return
        }
        DataService.shared.placeOrder(order: order, card: card) { (success, error) in
            if let _ = error {
                self.proceedView.proceedButton.hideLoading()
            } else {
                self.overView.order = nil
                self.order.removeAll()
                self.orderDetails.removeAll()
                self.view.showMessage("Order placed", type: .success)
                self.cardState = .empty
                self.proceedView.proceedButton.hideLoading()
                self.adapter.performUpdates(animated: true)
            }
        }
    }
    
    @objc func cancel() {
        self.curtainController?.moveCurtain(to: .min, animated: true)
    }
    
    
    func addCardAlert() {
        let alert = UIAlertController(title: "Add Card", message: "Add a card before placing your order.", preferredStyle: .alert)
        let addCard = UIAlertAction(title: "Add a Card", style: .default) { (action) in
            let paymentViewController =  PaymentViewController()
            guard let user = self.user else { return }
            paymentViewController.userFullName = "\(user.firstName ?? "") \(user.lastName ?? "")"
            self.navigationController?.pushViewController(paymentViewController, animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addCard)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
        self.proceedView.proceedButton.hideLoading()
    }
    
    func clearBagAlert(orderId: String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let addCard = UIAlertAction(title: "Clear bag", style: .destructive) { (action) in
            DataService.shared.clearOrder(orderId: orderId) { (success, error) in
                if !success! {

                } else {
                    self.cardState = .empty
                    self.overView.order = nil
                    self.order.removeAll()
                    self.orderDetails.removeAll()
                    self.proceedView.clearButton.hideLoading()
                    self.adapter.performUpdates(animated: true)
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)  { (action) in
            self.proceedView.clearButton.hideLoading()
        }
        alert.addAction(addCard)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - CurtainDelegate
extension CardViewController: CurtainDelegate {
    
    func curtain(_ curtain: Curtain, didChange heightState: CurtainHeightState) {
        
        if cardState == .overview {
            switch heightState {
            case .min:
                emptyView.isHidden = true
                overView.isHidden = true
                cardState = .notEmpty
            case .mid:
                overView.isHidden = false
            case .max:
                overView.isHidden = false
            default:
                break
            }
        }
        
        if cardState == .notEmpty {
            switch heightState {
            case .min:
                self.navigationItem.leftBarButtonItem = nil
                let quantity = self.order.first?.quantity
                self.titleViewLabel.text = "View Bag - \(quantity ?? 0)"
                emptyView.isHidden = true
                collectionView.isHidden = true
                proceedView.isHidden = true
            case .mid:
                self.navigationItem.leftBarButtonItem = cancelButton
                collectionView.isHidden = false
                proceedView.isHidden = false
            case .max:
                self.navigationItem.leftBarButtonItem = cancelButton
                collectionView.isHidden = false
                proceedView.isHidden = false
            default:
                break
            }
        } else {
            switch heightState {
            case .min:
                self.navigationItem.leftBarButtonItem = nil
                self.titleViewLabel.text = "View Bag"
                emptyView.isHidden = true
                collectionView.isHidden = true
            case .mid:
                self.navigationItem.leftBarButtonItem = cancelButton
                emptyView.isHidden = false
                collectionView.isHidden = true
            case .max:
                emptyView.isHidden = false
                collectionView.isHidden = true
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
        var data = orderDetails as [ListDiffable]
        data += menus as [ListDiffable]
        data += card as [ListDiffable]
        data += order as [ListDiffable]
        return data
    }
    
    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        if object is String {
            return OrderInfoSection() 
        } else if object is Menu {
            return OrderMenuSection()
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
