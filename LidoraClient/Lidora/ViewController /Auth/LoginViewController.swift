//
//  LoginViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/23/20.
//

import UIKit
import WebKit

enum AuthChoice {
    case login
    case register
}

class AuthViewController: UIViewController {
    
    var label = UILabel()
    var descriptionLabel = UILabel()
    
    var stackView: UIStackView!
    
    var detailField = FieldRect()
    var phoneTextField = FieldRect()
    var passwordField = FieldRect()
    var nextButton = LoadingButton()
    
    var legalButton = UIButton()
    
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
        descriptionLabel.font = UIFont.systemFont(ofSize: 17)
        descriptionLabel.textColor = .lightGray
        descriptionLabel.sizeToFit()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        detailField.keyboardType = .emailAddress
        detailField.autocorrectionType = .no
        detailField.autocapitalizationType = .none
        detailField.placeholder = "Email address"
        detailField.translatesAutoresizingMaskIntoConstraints = false
        detailField.setBorder()
        
        phoneTextField.keyboardType = .emailAddress
        phoneTextField.autocorrectionType = .no
        phoneTextField.autocapitalizationType = .none
        phoneTextField.keyboardType = .phonePad
        phoneTextField.placeholder = "Phone number"
        phoneTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneTextField.setBorder()
        
        passwordField.isSecureTextEntry = true
        passwordField.backgroundColor = .systemGray6
        passwordField.placeholder = "Password"
        passwordField.textContentType = .password
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.setBorder()

        stackView = UIStackView(arrangedSubviews: [detailField, phoneTextField, passwordField])
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        nextButton.setTitle("Log In", for: .normal)
        nextButton.addTarget(self, action: #selector(self.nextStep), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textChanged), name: UITextField.textDidChangeNotification, object: nil)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextButton)
        
        view.addSubview(legalButton)
        legalButton.setTitle("By signing up, you agree to our Terms & Policy", for: .normal)
        legalButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        legalButton.setTitleColor(.gray, for: .normal)
        legalButton.translatesAutoresizingMaskIntoConstraints = false
        legalButton.addTarget(self, action: #selector(self.showLegals), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
        
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 80.0),
            label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -56.0),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8.0),
            descriptionLabel.leftAnchor.constraint(equalTo: label.leftAnchor),
        
            stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16.0),
            stackView.leftAnchor.constraint(equalTo: label.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: label.rightAnchor, constant: -16.0),
            
            detailField.heightAnchor.constraint(equalToConstant: 50.0),

            nextButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 16.0),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.widthAnchor.constraint(equalTo: label.widthAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 46.0),
            
            legalButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 8.0),
            legalButton.leftAnchor.constraint(equalTo: label.leftAnchor)
        ])
    }
    
    func updateViews() {
        if authChoice == .login {
            self.label.text = "Welcome to Lidora"
            self.descriptionLabel.text = "Log back into your account"
            self.nextButton.setTitle("Log In", for: .normal)
            self.phoneTextField.removeFromSuperview()
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

        guard let email = self.detailField.text, let phone = self.phoneTextField.text, let pwd = self.passwordField.text else {
            return
        }
        
        let vc = UsernameViewController()
        vc.data.append(email)
        vc.data.append(phone)
        vc.data.append(pwd)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showLegals() {
        let viewController = WebViewController()
        let nav = UINavigationController(rootViewController: viewController)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc func textChanged() {
        if detailField.hasText && passwordField.hasText {
            nextButton.enable()
        } else {
            nextButton.disable()
        }
    }
}
