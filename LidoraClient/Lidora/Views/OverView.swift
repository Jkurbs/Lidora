//
//  OverView.swift
//  Lidora
//
//  Created by Kerby Jean on 9/11/20.
//

import UIKit
import SDWebImage

class OverView: UIView {
    
    var imageView = UIImageView()
    var nameLabel = UILabel()
    var textView = UITextView()
    var stepper = UIStepper()
    var menu: Menu?
    var chef: Chef?
    var orders = [Order]()
    var arrayOfMenu = [Menu]()
    var roundedString: String?
    
    let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1)
        return view
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10.0
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitle("Add to bag", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addToOrder), for: .touchUpInside)
        addSubview(button)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 10
    }
    
    
    func setupViews() {
        backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews(_:)), name: NSNotification.Name("menu"), object: nil)
        
        translatesAutoresizingMaskIntoConstraints = false 
        addSubview(imageView)
        imageView.image = UIImage(named: "food3")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        nameLabel.text = "Food name"
        
        addSubview(textView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt"
        textView.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textView.isUserInteractionEnabled = false
        textView.sizeToFit()
        
        addSubview(separator)
        
        addSubview(stepper)
        stepper.addTarget(self, action: #selector(increment(_:)), for: .touchUpInside)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 1
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16.0),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            nameLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            nameLabel.rightAnchor.constraint(equalTo: imageView.rightAnchor, constant: -16.0),
            textView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0.0),
            textView.leftAnchor.constraint(equalTo: nameLabel.leftAnchor, constant: -5.0),
            textView.rightAnchor.constraint(equalTo: imageView.leftAnchor, constant: -16.0),
            textView.heightAnchor.constraint(equalToConstant: 60.0),
            separator.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16.0),
            separator.widthAnchor.constraint(equalTo: widthAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            
            stepper.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 60.0),
            stepper.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24.0),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.widthAnchor.constraint(equalTo: widthAnchor, constant: -32.0),
            button.heightAnchor.constraint(equalToConstant: 60.0)
        ])
    }
    
    @objc func increment(_ stepper: UIStepper) {
        let quantity = stepper.value
        guard let menu = self.menu, let price = menu.price else { return }
        let finalPrice = Double(price) * quantity
        button.setTitle("Add \(Int(stepper.value)) to bag - $\(finalPrice)", for: .normal)
    }
    
    @objc func addToOrder() {
        guard let item = self.menu else { return  }
        let quantity = Int(self.stepper.value)
        let total = (menu?.price)! * Double(quantity)
        NotificationCenter.default.post(name: .addToBag, object: self, userInfo: ["item": item, "total": total, "quantity": quantity])
        self.stepper.value = 1
        button.setTitle("Add \(Int(stepper.value)) to bag - $\(item.price ?? 0.0)", for: .normal)
    }
    
    @objc func updateViews(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let menu = userInfo["menu"] as? Menu {
                self.menu = menu
                imageView.sd_setImage(with: URL(string: menu.imageURL))
                nameLabel.text = menu.name
                textView.text = menu.description
                button.setTitle("Add \(Int(stepper.value)) to bag - $\(menu.price ?? 0.0)", for: .normal)
            }
        }
    }
}
