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
    var dateLabel = UILabel()

    
    var order: Order? {
        didSet {
            imageView.sd_setImage(with: URL(string: order!.providerImageURL))
            nameLabel.text = order?.providerName
            dateLabel.text = order?.createdDate
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
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        nameLabel.backgroundColor = UIColor(white: 0.3, alpha: 0.5)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        
        addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.textColor = .darkText
        dateLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)

        
        NSLayoutConstraint.activate([
            
            imageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nameLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            nameLabel.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            nameLabel.heightAnchor.constraint(equalTo: imageView.heightAnchor),

            dateLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16.0) ,
            dateLabel.widthAnchor.constraint(equalTo: widthAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: 30),
            dateLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor),
        ])
    }
}
