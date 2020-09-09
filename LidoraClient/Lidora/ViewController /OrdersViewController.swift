//
//  OrdersViewController.swift
//  Lidora
//
//  Created by Kerby Jean on 9/8/20.
//

import UIKit

class OrdersViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
    }
    

    func setupViews() {
        self.title = "Orders"
        view.backgroundColor = .white
    }
}
