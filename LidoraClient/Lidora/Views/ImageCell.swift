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
        
            imageView.heightAnchor.constraint(equalTo: heightAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalTo: widthAnchor)
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
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            label.topAnchor.constraint(equalTo: topAnchor),
        
            descriptionLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6.0),
            descriptionLabel.leftAnchor.constraint(equalTo: label.leftAnchor)
        ])
    }
    
    func setupViews() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .medium)
        addSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .light)
        contentView.layer.addSublayer(separator)
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 16.0, y: bounds.height - height, width: bounds.width, height: height)
    }
}
