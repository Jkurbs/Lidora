//
//  LocationView.swift
//  Lidora
//
//  Created by Kerby Jean on 9/6/20.
//

import UIKit

class LocationView: UIView {
    
    let imageView = UIImageView()
    let label = UILabel()
    let button = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        backgroundColor = .white
        
        addSubview(imageView)
        let originalImage = UIImage(systemName: "location")
        let image = originalImage?.withTintColor(.darkText, renderingMode: .alwaysOriginal)
        imageView.image = image

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        label.text = "14212 NE 3RD CT"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(button)
        let chevronOriginalImage = UIImage(systemName: "chevron.right")
        let chevronImage = chevronOriginalImage?.withTintColor(.darkText, renderingMode: .alwaysOriginal)
        button.setImage(chevronImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false

        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 5.0),
            label.heightAnchor.constraint(equalTo: heightAnchor),
            button.widthAnchor.constraint(equalToConstant: 15),
            button.heightAnchor.constraint(equalToConstant: 15),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 5),
            
        ])
    }
    
    func updateViews() {
        
    }
}
