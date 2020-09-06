//
//  MainViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/6/20.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        self.title = "Near you"
    }
}
