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
    var providerName: String!
    var providerImageURL: String!
    var items: [Menu]?
    var quantity: Int!
    var subtotal: Double!
    var platformFee: Double!
    var stripeFee: Double!
    var serviceFee: Double!
    var total: Double!
    
    init(key: String, providerId: String, providerName: String, items: [Menu]?, quantity: Int, total: Double) {
        self.id = key
        self.providerId = providerId
        self.providerName = providerName
        self.items = items
        self.quantity = quantity
        self.total = total
    }
    
    init(key: String, data: [String: Any]) {
        self.id = key
        self.providerId = data["provider_id"] as? String
        self.providerName = data["provider_name"] as? String
        self.providerImageURL = data["provider_imageURL"] as? String
        self.items = data["menu"] as? [Menu]
        self.quantity = data["quantity"] as? Int
        self.subtotal = data["subtotal"] as? Double
        self.platformFee = data["platform_fee"] as? Double
        self.stripeFee = data["stripe_fee"] as? Double
        self.serviceFee = data["service_fee"] as? Double
        self.total = data["total"] as? Double
        
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
