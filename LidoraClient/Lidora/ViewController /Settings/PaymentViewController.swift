//
//  PaymentViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/9/20.
//


import UIKit
import Stripe
import Firebase
import FormTextField

class PaymentViewController: UIViewController {
    
    var stackView: UIStackView!
    var detailsStackView: UIStackView!
    let descriptionLabel = UILabel()
    let card1ImageView = UIImageView()
    let card2ImageView = UIImageView()
    let card3ImageView = UIImageView()
    let card4ImageView = UIImageView()
    let securityLabel = UILabel()
    var button: LoadingButton!
    
    lazy var nameField: FormTextField = {
        let textField = FormTextField()
        textField.inputType = .name
        textField.accessoryViewMode = .never
        textField.placeholder = "Name on card"
        textField.borderStyle = .roundedRect
        textField.inputAccessoryView = buttonView
        return textField
    }()
    
    lazy var cardNumberField: FormTextField = {
        let textField = FormTextField()
        textField.inputType = .integer
        textField.accessoryViewMode = .never
        textField.formatter = CardNumberFormatter()
        textField.placeholder = "Card Number"
        textField.borderStyle = .roundedRect
        textField.inputAccessoryView = buttonView
        var validation = Validation()
        validation.maximumLength = "1234 5678 1234 5678".count
        validation.minimumLength = "1234 5678 1234 5678".count
        let characterSet = NSMutableCharacterSet.decimalDigit()
        characterSet.addCharacters(in: " ")
        validation.characterSet = characterSet as CharacterSet
        let inputValidator = InputValidator(validation: validation)
        textField.inputValidator = inputValidator
        return textField
    }()
    
    lazy var cardExpirationDateField: FormTextField = {
        let textField = FormTextField()
        textField.inputType = .integer
        textField.accessoryViewMode = .never
        textField.formatter = CardExpirationDateFormatter()
        textField.placeholder = "MM/YY"
        textField.borderStyle = .roundedRect
        textField.inputAccessoryView = buttonView
        var validation = Validation()
        validation.minimumLength = 1
        let inputValidator = CardExpirationDateInputValidator(validation: validation)
        textField.inputValidator = inputValidator
        return textField
    }()
    
    lazy var cvcField: FormTextField = {
        let textField = FormTextField()
        textField.inputType = .integer
        textField.accessoryViewMode = .never
        textField.placeholder = "CVC"
        textField.borderStyle = .roundedRect
        textField.inputAccessoryView = buttonView
        var validation = Validation()
        validation.maximumLength = "CVC".count
        validation.minimumLength = "CVC".count
        validation.characterSet = NSCharacterSet.decimalDigits
        let inputValidator = InputValidator(validation: validation)
        textField.inputValidator = inputValidator
        return textField
    }()
    
    lazy var buttonView: UIView = {
        let view = UIView()
        view.frame =  CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60)
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowRadius = 5.0
        let button = LoadingButton(type: .custom)
        self.button = button
        button.enable()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addPaymentMethod), for: .touchUpInside)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -60),
            button.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -20),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        return view
    }()
    
    
    var card: Card?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    
    func setupViews() {
        self.title = "Card Information"
        view.backgroundColor = .white
        
        descriptionLabel.text = "Credit or Debit card"
        card1ImageView.image = UIImage(named: "visa")
        card2ImageView.image = UIImage(named: "mastercard")
        card3ImageView.image = UIImage(named: "amex")
        card4ImageView.image = UIImage(named: "discover")
        
        card1ImageView.contentMode = .scaleAspectFit
        card2ImageView.contentMode = .scaleAspectFit
        card3ImageView.contentMode = .scaleAspectFit
        card4ImageView.contentMode = .scaleAspectFit
        
        detailsStackView = UIStackView(arrangedSubviews: [descriptionLabel, card1ImageView, card2ImageView, card3ImageView, card4ImageView])
        detailsStackView.axis = .horizontal
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(detailsStackView)
        
        securityLabel.text = "Your payment methods are saved and stored securely."
        securityLabel.font = UIFont.systemFont(ofSize: 13)
        securityLabel.textColor = .lightGray
        securityLabel.textAlignment = .center
        
        stackView = UIStackView(arrangedSubviews: [nameField, cardNumberField, cardExpirationDateField, cvcField, securityLabel])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            detailsStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            detailsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            detailsStackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -40),
            detailsStackView.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.topAnchor.constraint(equalTo: detailsStackView.bottomAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -30),
            stackView.heightAnchor.constraint(equalToConstant: view.frame.height/2.8),
        ])
    }
    
    func updateViews() {
        if card != nil {
            // Update
        } else {
            // Do nothing
        }
    }
    
    
    
    @objc func addPaymentMethod(_ button: UIButton) {
        
        guard cardNumberField.validate(), cardExpirationDateField.validate(), cvcField.validate() else { return }
        
        let cardParams = STPCardParams()
        cardParams.number = cardNumberField.text
        
        self.button.showLoading()

        if let expirationText = cardExpirationDateField.text {
            let monthStartIndex = expirationText.index(expirationText.startIndex, offsetBy: 0)
            let monthEndIndex = expirationText.index(monthStartIndex, offsetBy: 2)
            let expMonth = (expirationText[monthStartIndex..<monthEndIndex])
            let month = UInt(expMonth)!
            let yearStartIndex = expirationText.index(expirationText.startIndex, offsetBy: 3)
            let yearEndIndex = expirationText.index(expirationText.endIndex, offsetBy: 0)
            let expYear = (expirationText[yearStartIndex..<yearEndIndex])
            let year = UInt(expYear)!
        
            DataService.shared.getStripeToken(cardNumber: cardNumberField.text!, month: month, year: year, cvc: cvcField.text!) { (success, error) in
                if !success {
                    print("Error: ", error!)
                    self.button.hideLoading()
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.button.hideLoading()
                        self.view.showMessage("Card successfully added", type: .success)
                    }
                }
            }
        }
    }
    
    func disable() {
        navigationItem.backBarButtonItem?.isEnabled = false
        buttonView.isUserInteractionEnabled = false 
        
    }
}


extension PaymentViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameField {
            cardNumberField.becomeFirstResponder()
        } else if textField == cardNumberField {
            cardExpirationDateField.becomeFirstResponder()
        } else if textField == cardExpirationDateField {
            cvcField.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
        return true
    }
}

