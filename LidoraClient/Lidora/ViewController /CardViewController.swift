//
//  CardViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/6/20.
//

import UIKit

class CardViewController: UIViewController {
    
    var label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.layer.cornerRadius = 10.0
        view.backgroundColor = UIColor(white: 0.5, alpha: 1.0)
        label.text = "Add to card"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = .white
        label.frame = CGRect(x: 0, y: 5, width: view.frame.width, height: 60)
        view.addSubview(label)
    }
}
