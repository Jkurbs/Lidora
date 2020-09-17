//
//  LocationView.swift
//  Lidora
//
//  Created by Kerby Jean on 9/6/20.
//

import UIKit

class LocationView: UIView {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let label = UILabel()
    let dateLabel = UILabel()
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
        
        backgroundColor = UIColor.tertiarySystemGroupedBackground
        
        addSubview(imageView)
        let originalImage = UIImage(systemName: "location")
        let image = originalImage?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        imageView.image = image

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        titleLabel.text = "Near you"
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        titleLabel.textColor = .darkText
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(dateLabel)
        dateLabel.text = CachedDateFormattingHelper.shared.formatTodayDate().uppercased()
        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        dateLabel.textColor = .gray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        label.text = "14212 NE 3RD CT"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true 
        
        addSubview(chevroImageView)
        let chevronOriginalImage = UIImage(systemName: "chevron.down")
        let chevronImage = chevronOriginalImage?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        chevroImageView.image = chevronImage
        chevroImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            dateLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor),
            
            titleLabel.leftAnchor.constraint(equalTo: imageView.leftAnchor),
            titleLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor),
            
            label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 5.0),
            label.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8.0),

            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16.0),
            imageView.centerYAnchor.constraint(equalTo: label.centerYAnchor),

            chevroImageView.widthAnchor.constraint(equalToConstant: 15),
            chevroImageView.heightAnchor.constraint(equalToConstant: 15),
            chevroImageView.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            chevroImageView.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 5),
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews(_:)), name: NSNotification.Name("userLocation"), object: self)
    }
    
    @objc func updateViews(_ address: String) {
        self.label.text = address
    }
}
