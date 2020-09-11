//
//  InfoCell.swift
//  Lidora
//
//  Created by Kerby Jean on 9/10/20.
//

import UIKit

class InfoCell: UICollectionViewCell {
    
    var label = UILabel()
    var descriptionLabel = UILabel()
    var imageView = UIImageView()
    
    let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
        return layer
    }()
    
    var chef: Chef? {
        didSet {
            
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
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0),

            imageView.heightAnchor.constraint(equalToConstant: 22),
            imageView.widthAnchor.constraint(equalToConstant: 22),
            imageView.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
    }
    
    func setupViews() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.text = "Schedule"
        
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.contentMode = .scaleAspectFit
        
        contentView.layer.addSublayer(separator)
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 16.0, y: bounds.height - height, width: bounds.width, height: height)

    }
}

