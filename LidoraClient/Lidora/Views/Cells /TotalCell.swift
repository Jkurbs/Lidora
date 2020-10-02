//
//  TotalCell.swift
//  Lidora
//
//  Created by Kerby Jean on 9/19/20.
//

import UIKit

class TotalCell: UICollectionViewCell {
    
    var label = UILabel()
    var priceLabel = UILabel()
    
    let separator: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(red: 200 / 255.0, green: 199 / 255.0, blue: 204 / 255.0, alpha: 1).cgColor
        return layer
    }()
    
    var order: Order? {
        didSet {
            guard let order = order else { return }
            label.text = "Subtotal"
            priceLabel.text = "$\(order.total ?? 0.0)"
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
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            priceLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16.0),
            priceLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    func setupViews() {
        
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        
        addSubview(priceLabel)
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)

        
        contentView.layer.addSublayer(separator)
        let height: CGFloat = 0.5
        separator.frame = CGRect(x: 16.0, y: bounds.height - height, width: bounds.width, height: height)
    }
    
    func updateViews(title: String, value: Double?) {
        label.text = title
        priceLabel.text = "$\(value ?? 0.0)"
    }
}
