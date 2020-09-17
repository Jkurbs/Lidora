//
//  TitleView .swift
//  Lidora
//
//  Created by Kerby Jean on 9/13/20.
//

import UIKit

class TitleView: UIView {
    
    var cardButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        cardButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        cardButton.titleLabel?.textColor = .lightText
        cardButton.translatesAutoresizingMaskIntoConstraints = false
        cardButton.setTitle("View Bag", for: .normal)
        
        addSubview(cardButton)
        
        NSLayoutConstraint.activate([
            cardButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            cardButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            cardButton.widthAnchor.constraint(equalTo: widthAnchor),

        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
