//
//  HeaderCell.swift
//  Lidora
//
//  Created by Kerby Jean on 9/19/20.
//

import UIKit

class HeaderCell: UICollectionViewCell {
    
    var label = UILabel()
    
    var title: String! {
        didSet {
            label.text = title
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            label.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
