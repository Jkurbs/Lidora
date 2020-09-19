//
//  Card.swift
//  Lidora
//
//  Created by Kerby Jean on 9/9/20.
//

import IGListKit

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
    var cardNumber: String!
    var cvv: String!
    var brand: CardBrand!
    var last4: String!
    var month: UInt!
    var year: UInt!
    var primary: Bool?
    
    init(id: String, data: [String: Any]) {
        self.id = id
        
        guard let brandData = data["brand"] as? String, let last4 = data["last4"] as? String, let month = data["month"] as? UInt, let year = data["year"] as? UInt, let cardNumber = data["number"] as? String, let cvv = data["cvc"] as? String, let brand = CardBrand(rawValue: brandData), let primary =  data["primary"] as? Bool  else { return }
        
        self.brand = brand
        self.last4 = last4
        self.month = month
        self.year = year
        self.cardNumber = cardNumber
        self.cvv = cvv
        self.primary = primary
    }
}

extension Card: Equatable {
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id
    }
}



extension Card: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        id as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? Card else { return false }
        return self.id != object.id
    }
}
