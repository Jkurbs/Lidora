//
//  ImageCell.swift
//  Lidora
//
//  Created by Kerby Jean on 9/10/20.
//

import UIKit
import SDWebImage

class ImageCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var label = UILabel()
    
    
    var stackView1 = UIStackView()
    var stackView2 = UIStackView()
    var stackView3 = UIStackView()
    var stackView4 = UIStackView()

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
    
    
    
    
    
    var descriptionLabel = UILabel()

    var chef: Chef? {
        didSet {
            imageView.sd_setImage(with: URL(string: chef!.imageURL), completed: nil)
            label.text = "\(chef?.firstName ?? "") \(chef?.lastName ?? "")"
            descriptionLabel.text = chef?.description
        }
    }
    
    let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
        return layer
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
        imageView.layer.cornerRadius = imageView.frame.width/2
    }
    
    func setupViews() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = imageView.frame.width/2
        addSubview(imageView)
        
        let originalTimerImage = UIImage(systemName: "timer")
        let timerImage = originalTimerImage?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        
        imageView2.image = UIImage(named: "user1")
        imageView2.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        imageView2.clipsToBounds = true
        imageView2.contentMode = .scaleAspectFill
        imageView2.translatesAutoresizingMaskIntoConstraints = false
        

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



        nameLabel3.text = "$0.30 Delivery Fee"
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

        
        
        
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        
        
//        addSubview(descriptionLabel)
//        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
//        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
//        descriptionLabel.numberOfLines = 4
        contentView.layer.addSublayer(separator)
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 16.0, y: bounds.height - height, width: bounds.width, height: height)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, constant: -50.0),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),

            label.topAnchor.constraint(equalTo: imageView.topAnchor),
            label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16.0),
                        
            imageView2.widthAnchor.constraint(equalToConstant: 30),
            imageView2.heightAnchor.constraint(equalToConstant: 30),

            imageView3.widthAnchor.constraint(equalToConstant: 20),
            imageView3.heightAnchor.constraint(equalToConstant: 20),

            imageView4.widthAnchor.constraint(equalToConstant: 20),
            imageView4.heightAnchor.constraint(equalToConstant: 20),

            imageView5.widthAnchor.constraint(equalToConstant: 20),
            imageView5.heightAnchor.constraint(equalToConstant: 20),

            stackView2.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8.0),
            stackView2.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16.0),

            stackView3.topAnchor.constraint(equalTo: stackView2.bottomAnchor, constant: 8.0),
            stackView3.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16.0),

//            descriptionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.0),
//            descriptionLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor),
//            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0)
        ])
    }
}

class TitleCell: UICollectionViewCell {
    
    var label = UILabel()
    var descriptionLabel = UILabel()
    
    let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
        return layer
    }()
    
    var chef: Chef? {
        didSet {
            label.text = "\(chef?.firstName ?? "") \(chef?.lastName ?? "")"
            descriptionLabel.text = chef?.description
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            
            descriptionLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            descriptionLabel.leftAnchor.constraint(equalTo: label.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0)
        ])
    }
    
    func setupViews() {
        self.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 10
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.numberOfLines = 4
        contentView.layer.addSublayer(separator)
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 16.0, y: bounds.height - height, width: bounds.width, height: height)
    }
}
