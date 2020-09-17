//
//  Card.swift
//  Lidora
//
//  Created by Kerby Jean on 9/9/20.
//

import Foundation

enum CardBrand: String, CaseIterable {
    case visa
    case mastercard
    case amex
    case discovery
    
    var values: String {
        switch self {
        case .visa:
            return "visa"
        case .mastercard:
            return "mastercard"
        case .amex:
            return "amex"
        case .discovery:
            return "discovery"
        }
    }
}

class Card {
    
    var id: String!
    var brand: CardBrand!
    var last4: String!
    var month: Int!
    var year: Int!
    
    init(id: String, data: [String: Any]) {
        self.id = id
        
        guard let brandData = data["brand"] as? String,  let brand = CardBrand(rawValue: brandData ), let last4 = data["last4"] as? String, let month = data["month"] as? Int, let year = data["year"] as? Int   else { return }
        
        self.brand = brand
        self.last4 = last4
        self.month = month
        self.year = year
    }
}
