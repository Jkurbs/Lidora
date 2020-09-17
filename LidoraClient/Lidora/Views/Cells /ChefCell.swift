//
//  ChefCell.swift
//  Lidora
//
//  Created by Kerby Jean on 9/6/20.
//

import UIKit

class ChefCell: UICollectionViewCell {
    
    
    var userImageView = UIImageView()
    var nameLabel = UILabel()
    var stackView = UIStackView()
    var deliveryTimeLabel = UILabel()
    var deliveryFeeLabel = UILabel()
    var detailsStackView = UIStackView()
    var textView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        
        backgroundColor = .white
        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor(white: 0.9, alpha: 1.0).cgColor
        
        addSubview(userImageView)
        userImageView.image = UIImage(named: "user1")
        userImageView.clipsToBounds = true
        userImageView.contentMode = .scaleAspectFill
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.backgroundColor = .red
        
        addSubview(nameLabel)
        nameLabel.text = "With Paola"
        nameLabel.font = UIFont.systemFont(ofSize: 22)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .darkText
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let imageView1 = UIImageView(image: UIImage(named:  "food1"))
        imageView1.contentMode = .scaleAspectFill
        
        let imageView2 = UIImageView(image: UIImage(named:  "food3"))
        imageView2.contentMode = .scaleAspectFill
        
        let imageView3 = UIImageView(image: UIImage(named:  "food2"))
        imageView3.contentMode = .scaleAspectFill

        stackView = UIStackView(arrangedSubviews: [imageView1, imageView2, imageView3])
        addSubview(stackView)

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.clipsToBounds = true
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textView)
        textView.text = "Traditional French cuisine prepare with a Venezuelan flair."
        textView.textColor = .darkText
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.isUserInteractionEnabled = false
        textView.clipsToBounds = true
        textView.sizeToFit()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        deliveryFeeLabel.text = "1 day pre-order"
        deliveryFeeLabel.font = UIFont.systemFont(ofSize: 13)
        deliveryTimeLabel.text = "$2.99 Delivery Fee"
        deliveryTimeLabel.font = UIFont.systemFont(ofSize: 13)
        
        detailsStackView = UIStackView(arrangedSubviews: [deliveryTimeLabel, deliveryFeeLabel])
        addSubview(detailsStackView)

        detailsStackView.axis = .horizontal
        detailsStackView.distribution = .fillEqually
        detailsStackView.clipsToBounds = true
        detailsStackView.spacing = 15
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            userImageView.widthAnchor.constraint(equalToConstant: 90),
            userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor),
            userImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 0.0),
            nameLabel.widthAnchor.constraint(equalTo: widthAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 15),
            stackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -20.0),
            stackView.heightAnchor.constraint(equalToConstant: 70.0),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),

            textView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10),
            textView.widthAnchor.constraint(equalTo: widthAnchor, constant: -20),
            textView.centerXAnchor.constraint(equalTo: centerXAnchor),
            textView.heightAnchor.constraint(equalToConstant: 50),
            
            detailsStackView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 0),
            detailsStackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -20.0),
            detailsStackView.heightAnchor.constraint(equalToConstant: 30.0),
            detailsStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userImageView.layer.cornerRadius = userImageView.frame.width/2
        detailsStackView.layer.cornerRadius = 10


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var chef: Chef? {
        didSet {
            print("CHEF SETUP")
        }
    }
}
