//
//  SettingsViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/7/20.
//

import UIKit
import FirebaseAuth

// Setting options
enum Settings: String, CaseIterable {
    
    case payment = "Payment"
    case password = "Password"
    case logOut = "Log Out"
    
    var values: String {
        switch self {
        case .payment:
            return "Payment"
        case .password:
            return "Password"
        case .logOut:
            return "Log Out"
        }
    }
}

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    var tableView: UITableView!
    var settings = Settings.allCases
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Options"
        
        view.backgroundColor = .systemBackground
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: displayWidth, height: displayHeight))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        self.view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Functions
            
     func logoutAlert() {
      let alert = UIAlertController(title: "Log Out", message: nil, preferredStyle: .alert)
      let logOut = UIAlertAction(title: "Log Out", style: .default) { _ in
          let firebaseAuth = Auth.auth()
        
//          UserDefaults.standard.removeObject(forKey: .userId)
//
//          do {
//              try firebaseAuth.signOut()
//
//              let navigation = UINavigationController(rootViewController: AuthVC())
//
//              navigation.modalPresentationStyle = .fullScreen
//              self.navigationController?.present(navigation, animated: true, completion: nil)
//          } catch let error as NSError {
//              NSLog("Error signing out: \(error)")
//          }
      }
      let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      alert.addAction(logOut)
      alert.addAction(cancel)
      self.present(alert, animated: true, completion: nil)
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemBackground
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        cell.textLabel?.text = settings[indexPath.row].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let row = indexPath.row
        if row == 0 {
          let paymentViewController = PaymentViewController()
          navigationController?.pushViewController(paymentViewController, animated: true)
        } else if row == 1 {
           
        } else {
            logoutAlert()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60.0
    }
}
