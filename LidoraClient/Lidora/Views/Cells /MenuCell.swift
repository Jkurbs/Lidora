//
//  MenuCell.swift
//  Lidora
//
//  Created by Kerby Jean on 9/11/20.
//

import UIKit

class MenuCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var nameLabel = UILabel()
    var descriptionLabel = UILabel()
    var priceLabel = UILabel()
    
    var menu: Menu? {
        didSet {
            nameLabel.text = menu?.name
            descriptionLabel.text = menu?.description
            priceLabel.text =  "$\(menu?.price ?? 0.0)"
            imageView.sd_setImage(with: URL(string: (menu?.imageURL)!), completed: nil)
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
        imageView.layer.cornerRadius = 10
    }
    
    func setupViews() {
        
        addSubview(imageView)
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.systemFont(ofSize: 15)
        
        addSubview(descriptionLabel)
        descriptionLabel.textColor = .lightGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, constant: -20),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            nameLabel.rightAnchor.constraint(equalTo: imageView.leftAnchor, constant: -16.0),
            
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.0),
            descriptionLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
            descriptionLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor),
            
            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8.0),
            priceLabel.leftAnchor.constraint(equalTo: descriptionLabel.leftAnchor)
        ])
    }
}