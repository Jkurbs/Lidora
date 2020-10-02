//
//  CodeVerificationViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/25/20.
//

import UIKit
import FirebaseAuth

class CodeVerificationViewController: UIViewController {
    
    var label = UILabel()
    var textField = FieldRect()
    var nextButton = LoadingButton()
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = .white
        
        view.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 25)
        label.text = "Enter the code we've sent to \n \(data[1])"
        label.numberOfLines = 4
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(textField)
        textField.keyboardType = .numberPad
        textField.placeholder = "Activation number"
        textField.textContentType = .oneTimeCode
        textField.setBorder()
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.textChanged), name: UITextField.textDidChangeNotification, object: nil)
        
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
        
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 80.0),
            label.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64.0),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 16.0),
            textField.leftAnchor.constraint(equalTo: label.leftAnchor),
            textField.rightAnchor.constraint(equalTo: label.rightAnchor, constant: -16.0),
            textField.heightAnchor.constraint(equalToConstant: 45.0),

            nextButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16.0),
            nextButton.widthAnchor.constraint(equalTo: label.widthAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 48.0),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func nextStep() {
        self.nextButton.showLoading()
        if let code = textField.text {
            let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "authVerificationID")!, verificationCode: code)
            /// Link email with phone credential
            Auth.auth().currentUser?.link(with: credential, completion: { _, error in
                if let err = error {
                    print("Error:", err.localizedDescription)
                } else {
                    let locationViewController = LocationViewController()
                    locationViewController.title = "Delivery Location"
                    locationViewController.locationType = .register
                    locationViewController.title = "Location for Delivery"
                    self.navigationController?.pushViewController(locationViewController, animated: true)
                }
            })
        }
    }
    
    @objc func textChanged() {
        if textField.hasText {
            nextButton.enable()
        } else {
            nextButton.disable()
        }
    }
}
