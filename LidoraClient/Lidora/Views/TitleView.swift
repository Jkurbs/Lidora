//
//  TitleView .swift
//  Lidora
//
//  Created by Kerby Jean on 9/13/20.
//

import UIKit

class TitleView: UIView {
    
    var cardButton = UIButton()
    var titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        cardButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        cardButton.titleLabel?.textColor = .lightText
        cardButton.translatesAutoresizingMaskIntoConstraints = false
        cardButton.setTitle("View Bag", for: .normal)
        addSubview(cardButton)
        
//        titleLabel.text = "TEST"
//        titleLabel.textAlignment = .center
//        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .regular)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            cardButton.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            cardButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            cardButton.widthAnchor.constraint(equalTo: widthAnchor),
            cardButton.heightAnchor.constraint(equalToConstant: 40.0),
            
//            titleLabel.topAnchor.constraint(equalTo: cardButton.bottomAnchor),
//            titleLabel.widthAnchor.constraint(equalTo: widthAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
