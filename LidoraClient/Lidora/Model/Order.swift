//
//  Order.swift
//  Lidora
//
//  Created by Kerby Jean on 9/11/20.
//

import UIKit
import IGListKit

class Order {
    
    var id: String!
    var providerId: String!
    var items: [Menu]?
    var quantity: Int!
    var price: Double!
    
    init(key: String, providerId: String, items: [Menu]?, quantity: Int, price: Double) {
        self.id = key
        self.providerId = providerId
        self.items = items
        self.quantity = quantity
        self.price = price
    }
    
    init(key: String, data: [String: Any]) {
        self.id = key
        self.providerId = data["provider_id"] as? String
        self.items = data["menu"] as? [Menu]
        self.quantity = data["quantity"] as? Int
        self.price = data["price"] as? Double
    }
}

extension Order: Equatable {
    
    static func == (lhs: Order, rhs: Order) -> Bool {
        lhs.id == rhs.id
    }
}



extension Order: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        id as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? Order else { return false }
        return self.id != object.id
    }
}
