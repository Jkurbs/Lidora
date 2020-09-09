//
//  EmptyView.swift
//  Lidora
//
//  Created by Kerby Jean on 9/7/20.
//

import UIKit

class EmptyView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 57.0, weight: .medium, scale: .medium)
        let originalImage = UIImage(systemName: "bag", withConfiguration: symbolConfig)
        let image = originalImage?.withTintColor(.gray, renderingMode: .alwaysOriginal)

        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "There's nothing in your bag"
        label.font = UIFont.systemFont(ofSize: 16)
        label.backgroundColor = .clear
        addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.widthAnchor.constraint(equalTo: widthAnchor)
       ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
