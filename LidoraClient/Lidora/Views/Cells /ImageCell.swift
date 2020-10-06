//
//  ImageCell.swift
//  Lidora
//
//  Created by Kerby Jean on 9/10/20.
//

import UIKit
import ChameleonFramework
import SDWebImage

class ImageCell: UICollectionViewCell {
    
    var imageView = UIImageView()

    var imageURL: String? {
        didSet {
            imageView.sd_setImage(with: URL(string: imageURL!), completed: nil)
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
        
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: -100),
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
    }
    
    func setupViews() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
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
            label.topAnchor.constraint(equalTo: topAnchor),
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.widthAnchor.constraint(equalTo: widthAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6.0),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -32),
        ])
    }
    
    func setupViews() {
        
//        let blurEffect = UIBlurEffect(style: .extraLight)
//        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
//        blurredEffectView.frame = bounds
//        addSubview(blurredEffectView)
//
//        let colorTop =  UIColor.clear.cgColor
//            let colorBottom = UIColor(red: 255.0/255.0, green: 94.0/255.0, blue: 58.0/255.0, alpha: 1.0).cgColor
//
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [colorTop, colorBottom]
//        gradientLayer.locations = [0.0, 1.0]
//        gradientLayer.frame = bounds
                
//        blurredEffectView.contentView.layer.insertSublayer(gradientLayer, at:0)
        
        backgroundColor = .clear
        backgroundView = UIView()
        selectedBackgroundView = UIView()
        
        self.layer.backgroundColor = UIColor.clear.cgColor
        contentView.addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 35, weight: .medium)
        label.textAlignment = .center
        label.textColor = .white
        
        contentView.addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 10
        descriptionLabel.textColor = .white
    }
}
