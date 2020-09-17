//
//  Bag.swift
//  Lidora
//
//  Created by Kerby Jean on 9/16/20.
//

import UIKit

class Bag {
    
    var id: String?
    var quantity: Int?
    var total: Double?
    
    init(key: String, data: [String: Any]) {
        self.id = key
        self.quantity = data["quantity"] as? Int
        self.total = data["total"] as? Double
    }
}
