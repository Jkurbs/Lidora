//
//  UpcomingOrderCell.swift
//  Lidora
//
//  Created by Kerby Jean on 9/27/20.
//

import UIKit

class UpcomingOrderCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    var nameLabel = UILabel()
    var descriptionLabel = UILabel()
    var priceLabel = UILabel()
    
    var order: Order? {
        didSet {
            
            print("ORDER: ", order?.providerImageURL)
            
            imageView.sd_setImage(with: URL(string: order!.providerImageURL))
            nameLabel.text = order?.providerName
//            descriptionLabel.text = menu?.description
//            priceLabel.text =  "$\(menu?.price ?? 0.0)"
//            imageView.sd_setImage(with: URL(string: (menu?.imageURL)!), completed: nil)
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
            
            imageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
//            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
//            nameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
//            nameLabel.rightAnchor.constraint(equalTo: imageView.leftAnchor, constant: -16.0),
//
//            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.0),
//            descriptionLabel.leftAnchor.constraint(equalTo: nameLabel.leftAnchor),
//            descriptionLabel.rightAnchor.constraint(equalTo: nameLabel.rightAnchor),
//
//            priceLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8.0),
//            priceLabel.leftAnchor.constraint(equalTo: descriptionLabel.leftAnchor)
        ])
    }
}
