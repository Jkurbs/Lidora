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
    let chevroImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
        translatesAutoresizingMaskIntoConstraints = false 
        
        backgroundColor = UIColor(red: 243.0/255.0, green: 243.0/255.0, blue: 243.0/255.0, alpha: 1.0)
        
        addSubview(imageView)
        let originalImage = UIImage(systemName: "location")
        let image = originalImage?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        imageView.image = image

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        label.text = "14212 NE 3RD CT"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        addSubview(chevroImageView)
        let chevronOriginalImage = UIImage(systemName: "chevron.down")
        let chevronImage = chevronOriginalImage?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        chevroImageView.image = chevronImage
        chevroImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 5.0),
            label.heightAnchor.constraint(equalTo: heightAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevroImageView.widthAnchor.constraint(equalToConstant: 15),
            chevroImageView.heightAnchor.constraint(equalToConstant: 15),
            chevroImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevroImageView.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 5),
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews(_:)), name: NSNotification.Name("userLocation"), object: self)
    }
    
    @objc func updateViews(_ address: String) {
        print("Location received")
        self.label.text = address
    }
}
