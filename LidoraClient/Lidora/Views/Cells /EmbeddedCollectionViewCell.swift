//
//  EmbeddedCollectionViewCell.swift
//  Lidora
//
//  Created by Kerby Jean on 9/14/20.
//

import UIKit

final class EmbeddedCollectionViewCell: UICollectionViewCell {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.alwaysBounceVertical = false
        view.alwaysBounceHorizontal = true
        self.contentView.addSubview(view)
        return view
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.frame
    }
}
