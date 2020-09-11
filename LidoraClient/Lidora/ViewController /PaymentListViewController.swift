//
//  PaymentListViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/9/20.
//

import UIKit



class PaymentListViewController: UIViewController {
    
    // MARK: - Properties
    
    var tableView: UITableView!
    var cards = [Card]()
    
    lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.layer.position.y = 100
        indicator.layer.position.x = view.layer.position.x
        indicator.style = .medium
        indicator.backgroundColor = .red
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        
        self.title = "Payments"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add new Payment", style: .done, target: self, action: #selector(goToAddNewPaymentVC))
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .systemBackground
        tableView.tableFooterView = UIView()
        tableView.addSubview(indicator)
        self.view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCards()
    }
    
    // MARK: - Functions
    
    @objc func goToAddNewPaymentVC() {
        navigationController?.pushViewController(PaymentViewController(), animated: true)
    }
    
    func loadCards() {
        self.cards.removeAll()
        DataService.shared.getPaymentMethods { (card, error) in
            if let error = error {
                print("Error getting payment methods: ", error)
            } else {
                self.cards.append(card!)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.indicator.stopAnimating()
                }
            }
        }
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension PaymentListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let card = self.cards[indexPath.row]
        cell.backgroundColor = .systemBackground
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        
        switch card.brand {
        case .visa:
            cell.imageView?.image = UIImage(named: card.brand.rawValue)
        case .mastercard:
            cell.imageView?.image = UIImage(named: card.brand.rawValue)
        case .amex:
            cell.imageView?.image = UIImage(named: card.brand.rawValue)
        case .discovery:
            cell.imageView?.image = UIImage(named: card.brand.rawValue)
        }
        cell.textLabel?.text = "**\(card.last4)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let card = self.cards[indexPath.row]
        showAlert(index: indexPath.row,card: card)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }

    func showAlert(index: Int, card: Card) {
        let alert = UIAlertController(title: "Options", message: nil, preferredStyle: .actionSheet)
        let remove = UIAlertAction(title: "Remove", style: .destructive) { (action) in
            // Remove
            self.cards.remove(at: index)
            DataService.shared.removePaymentMethod(id: card.id) { (success, error) in
                if !success {
                    print("Error deleting payment method: ", error!)
                } else {
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(remove)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}

