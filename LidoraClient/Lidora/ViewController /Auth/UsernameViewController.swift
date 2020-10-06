//
//  UsernameViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/24/20.
//


import UIKit
import FirebaseAuth

class UsernameViewController: UIViewController {
    
    var label = UILabel()
    var firstNameTextField = FieldRect()
    var lastNameTextField = FieldRect()
    var errorLabel = UILabel()
    var nextButton = LoadingButton()
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(label)
        label.textAlignment = .center
        label.text = "Add your full name"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .center
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(firstNameTextField)
        firstNameTextField.placeholder = "First name"
        firstNameTextField.setBorder()
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lastNameTextField)
        lastNameTextField.placeholder = "Last name"
        lastNameTextField.setBorder()
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(errorLabel)
        errorLabel.font = UIFont.systemFont(ofSize: 10)
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(self.textChanged), name: UITextField.textDidChangeNotification, object: nil)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
        
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 80.0),
            label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64.0),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            firstNameTextField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24.0),
            firstNameTextField.widthAnchor.constraint(equalTo: label.widthAnchor),
            firstNameTextField.heightAnchor.constraint(equalToConstant: 48.0),
            firstNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            lastNameTextField.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 8.0),
            lastNameTextField.widthAnchor.constraint(equalTo: label.widthAnchor),
            lastNameTextField.heightAnchor.constraint(equalToConstant: 48.0),
            lastNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nextButton.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 16.0),
            nextButton.widthAnchor.constraint(equalTo: label.widthAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 48.0),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    @objc func nextStep() {
        
        nextButton.showLoading()
        
        if let firstName = firstNameTextField.text, let lastName = lastNameTextField.text, let email = data.first, let password = data.last {
                
            let phone = data[1]
            
            AuthService.shared.createAccount(firstName: firstName, lastName: lastName, email: email, phone: "+1\(phone)", pwd: password) { _, error in
                if let error = error {
                    NSLog("error: \(error)")
                    self.nextButton.hideLoading()
                } else {
                    self.nextButton.hideLoading()
                    let vc = CodeVerificationViewController()
                    vc.data = self.data
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @objc func back() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    @objc func textChanged() {
        if firstNameTextField.hasText && lastNameTextField.hasText {
            nextButton.enable()
        } else {
            nextButton.disable()
        }
    }
}
