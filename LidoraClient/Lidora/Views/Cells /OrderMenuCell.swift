//
//  OrderCell.swift
//  Lidora
//
//  Created by Kerby Jean on 9/13/20.
//

import UIKit

class OrderMenuCell: UICollectionViewCell {
    
    var label = UILabel()
    var quantityLabel = UILabel()
    var priceLabel = UILabel()
    var descriptionLabel = UILabel()
    
    let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
        return layer
    }()
    
    var menu: Menu? {
        didSet {
            guard let menu = menu else { return }
            label.text = menu.name
            quantityLabel.text = "\(menu.quantity ?? 0)"
            priceLabel.text = "$\(menu.total ?? 0.0)"
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
            quantityLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            quantityLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leftAnchor.constraint(equalTo:  quantityLabel.rightAnchor, constant: 16.0),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func setupViews() {
        
        addSubview(quantityLabel)
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)

        
        contentView.layer.addSublayer(separator)
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 16.0, y: bounds.height - height, width: bounds.width, height: height)
    }
}


