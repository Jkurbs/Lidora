//
//  ChefCell.swift
//  Lidora
//
//  Created by Kerby Jean on 9/6/20.
//

import UIKit

class ChefCell: UICollectionViewCell {
    
    
    var view = UIView()
    var imageView1 = UIImageView()
    
    var stackView1 = UIStackView()
    var stackView2 = UIStackView()
    var stackView3 = UIStackView()
    var stackView4 = UIStackView()

    
    var nameLabel = UILabel()
    var imageView2 = UIImageView()
    
    var nameLabel2 = UILabel()
    var imageView3 = UIImageView()
    
    var nameLabel3 = UILabel()
    var imageView4 = UIImageView()
    
    var nameLabel4 = UILabel()
    var imageView5 = UIImageView()

    var deliveryTimeLabel = UILabel()
    var deliveryFeeLabel = UILabel()
    var detailsStackView = UIStackView()
    var textView = UITextView()
    
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 10.0
    private var fillColor: UIColor = .white

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews() {
        
        self.layer.cornerRadius = cornerRadius
//        backgroundColor = UIColor.tertiarySystemGroupedBackground
        
        
        
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.backgroundColor = .white
        
        addSubview(view)
        
        imageView1 = UIImageView(image: UIImage(named:  "food3"))
        imageView1.contentMode = .scaleAspectFill
        imageView1.clipsToBounds = true
        imageView1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView1)
        
        
        let originalTimerImage = UIImage(systemName: "timer")
        let timerImage = originalTimerImage?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        
        imageView2.image = UIImage(named: "user1")
        imageView2.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView2.clipsToBounds = true
        imageView2.contentMode = .scaleAspectFill
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.text = "Paola"
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        nameLabel.textColor = .darkText
        nameLabel.translatesAutoresizingMaskIntoConstraints = false


        stackView1 = UIStackView(arrangedSubviews: [imageView2, nameLabel])
        addSubview(stackView1)

        stackView1.axis = .horizontal
        stackView1.alignment = .center
        stackView1.distribution = .equalSpacing
        stackView1.spacing = 12
        stackView1.translatesAutoresizingMaskIntoConstraints = false


        imageView3.image = timerImage
        imageView3.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView3.clipsToBounds = true
        imageView3.contentMode = .scaleAspectFill

        nameLabel2.text = "1 day pre-order"
        nameLabel2.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        nameLabel2.textColor = .gray
        nameLabel2.translatesAutoresizingMaskIntoConstraints = false


        stackView2 = UIStackView(arrangedSubviews: [imageView3, nameLabel2])
        addSubview(stackView2)

        stackView2.axis = .horizontal
        stackView2.alignment = .center
        stackView2.distribution = .equalSpacing
        stackView2.spacing = 10
        stackView2.translatesAutoresizingMaskIntoConstraints = false


        let originalInfoImage = UIImage(systemName: "info.circle")
        let infoImage = originalInfoImage?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)

        imageView4.image = infoImage
        imageView4.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView4.clipsToBounds = true
        imageView4.contentMode = .scaleAspectFill
        imageView4.translatesAutoresizingMaskIntoConstraints = false



        nameLabel3.text = "$2.99 Delivery Fee"
        nameLabel3.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        nameLabel3.textColor = .gray
        nameLabel3.translatesAutoresizingMaskIntoConstraints = false


        stackView3 = UIStackView(arrangedSubviews: [imageView4, nameLabel3])
        addSubview(stackView3)

        stackView3.axis = .horizontal
        stackView3.alignment = .center
        stackView3.distribution = .equalSpacing
        stackView3.spacing = 10
        stackView3.translatesAutoresizingMaskIntoConstraints = false


        let originalDescImage = UIImage(systemName: "text.justifyleft")
        let descImage = originalDescImage?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)

        imageView5.image = descImage
        imageView5.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView5.clipsToBounds = true
        imageView5.contentMode = .scaleAspectFill
        imageView5.translatesAutoresizingMaskIntoConstraints = false

        nameLabel4.text = "Traditional French cuisine prepare with a Venezuelan flair."
        nameLabel4.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        nameLabel4.textColor = .gray
        nameLabel4.translatesAutoresizingMaskIntoConstraints = false


        stackView4 = UIStackView(arrangedSubviews: [imageView5, nameLabel4])
        addSubview(stackView4)

        stackView4.axis = .horizontal
        stackView4.alignment = .center
        stackView4.distribution = .equalSpacing
        stackView4.spacing = 10
        stackView4.translatesAutoresizingMaskIntoConstraints = false
        

        NSLayoutConstraint.activate([
            
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leftAnchor.constraint(equalTo: leftAnchor),
            view.rightAnchor.constraint(equalTo: rightAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.heightAnchor.constraint(equalTo: heightAnchor),

            imageView1.topAnchor.constraint(equalTo: topAnchor),
            imageView1.widthAnchor.constraint(equalToConstant: frame.size.width),
            imageView1.heightAnchor.constraint(equalToConstant: frame.size.height/2),
            
            imageView2.widthAnchor.constraint(equalToConstant: 30),
            imageView2.heightAnchor.constraint(equalToConstant: 30),

            imageView3.widthAnchor.constraint(equalToConstant: 20),
            imageView3.heightAnchor.constraint(equalToConstant: 20),

            imageView4.widthAnchor.constraint(equalToConstant: 20),
            imageView4.heightAnchor.constraint(equalToConstant: 20),

            imageView5.widthAnchor.constraint(equalToConstant: 20),
            imageView5.heightAnchor.constraint(equalToConstant: 20),

            stackView1.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: 16.0),
            stackView1.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),

            stackView2.topAnchor.constraint(equalTo: stackView1.bottomAnchor, constant: 8.0),
            stackView2.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),

            stackView3.topAnchor.constraint(equalTo: stackView2.bottomAnchor, constant: 8.0),
            stackView3.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),

            stackView4.topAnchor.constraint(equalTo: stackView3.bottomAnchor, constant: 8.0),
            stackView4.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            stackView4.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0),


        ])
        
        print("HEIGHT: ", self.frame.size.height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView2.layer.cornerRadius = imageView2.frame.width/2
        view.layer.cornerRadius = 10

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
          
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = fillColor.cgColor

            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.28
            shadowLayer.shadowRadius = 20

            layer.insertSublayer(shadowLayer, at: 0)
        }
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
