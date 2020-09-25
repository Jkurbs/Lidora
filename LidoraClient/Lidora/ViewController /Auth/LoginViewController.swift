//
//  LoginViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/23/20.
//

import UIKit
import Foundation

enum AuthChoice {
    case login
    case register
}

class AuthViewController: UIViewController {
    
    var label = UILabel()
    var descriptionLabel = UILabel()
    var detailField = FieldRect()
    var passwordField = FieldRect()
    var nextButton = LoadingButton()
    
    var authChoice = AuthChoice.login
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        updateViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
    }

    
    func setupViews() {
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 35)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(descriptionLabel)
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.textColor = .lightGray
        descriptionLabel.sizeToFit()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        detailField.keyboardType = .emailAddress
        detailField.autocorrectionType = .no
        detailField.autocapitalizationType = .none
        detailField.backgroundColor = .systemGray6
        detailField.placeholder = "email address"
        detailField.translatesAutoresizingMaskIntoConstraints = false
        detailField.setBorder()
        view.addSubview(detailField)
        
        passwordField.isSecureTextEntry = true
        passwordField.backgroundColor = .systemGray6
        passwordField.placeholder = "Password"
        passwordField.textContentType = .password
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.setBorder()
        view.addSubview(passwordField)
        
        nextButton.setTitle("Log In", for: .normal)
        nextButton.addTarget(self, action: #selector(self.nextStep), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textChanged), name: UITextField.textDidChangeNotification, object: nil)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
        
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 80.0),
            label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -56.0),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
            descriptionLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8.0),
            descriptionLabel.leftAnchor.constraint(equalTo: label.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: label.rightAnchor, constant: -16.0),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 32.0),
        
            detailField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40.0),
            detailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailField.widthAnchor.constraint(equalTo: label.widthAnchor),
            detailField.heightAnchor.constraint(equalToConstant: 46.0),
            
            passwordField.topAnchor.constraint(equalTo: detailField.bottomAnchor, constant: 8.0),
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.widthAnchor.constraint(equalTo: label.widthAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 46.0),
            
            nextButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16.0),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalTo: label.widthAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 46.0),
        ])
    }
    
    func updateViews() {
        if authChoice == .login {
            self.label.text = "Welcome to Lidora"
            self.descriptionLabel.text = "Log back into your account"
            self.nextButton.setTitle("Log In", for: .normal)
        } else {
            self.label.text = "Welcome to Lidora"
            self.descriptionLabel.text = "Create an account"
            self.nextButton.setTitle("Next", for: .normal)
        }
    }
    
    @objc func nextStep() {
        self.nextButton.showLoading()
        if let email = self.detailField.text, let pwd = self.passwordField.text {
            if authChoice == .login {
                login(detail: email, pwd: pwd)
            } else {
                registerNext()
            }
        }
    }
    
    
    func login(detail: String, pwd: String) {
        AuthService.shared.emailLogin(email: detail, pwd: pwd, complete: { userId, user, success, error  in
            if !success {
               // Show Error
            } else {
                let sceneDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
                self.nextButton.hideLoading()
                sceneDelegate.observeAuthorisedState()
            }
        })
    }
    
    func registerNext() {
        if let email = self.detailField.text, let pwd = self.passwordField.text {
            let vc = UsernameViewController()
            vc.data.append(email)
            vc.data.append(pwd)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @objc func textChanged() {
        if detailField.hasText && passwordField.hasText {
            nextButton.enable()
        } else {
            nextButton.disable()
        }
    }
}
