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
    
    let id: String
    let brand: CardBrand
    let last4: String
    let month: Int
    let year: Int
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.brand = CardBrand(rawValue:  (data["brand"] as? String)!)!
        self.last4 = data["last4"] as! String
        self.month = data["month"] as! Int
        self.year = data["year"] as! Int
    }
}
