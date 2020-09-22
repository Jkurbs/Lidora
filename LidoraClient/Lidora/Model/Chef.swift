//
//  Chef.swift
//  Lidora
//
//  Created by Kerby Jean on 9/6/20.
//

import IGListKit
import Foundation

class Chef {
    
    let id: String!
    let firstName: String!
    let lastName: String!
    let email: String!
    let phone: String!
    let dob: [Int]!
    let ssnLast4: String!
    let ssn: String!
    let imageURL: String!
    let thumbnailsURL: [String]!
    let description: String!
    let ip: String!
    var menu: Menu!
    
    init(key: String, data: [String: Any]) {
        self.id = key
        self.firstName = data["first_name"] as? String
        self.lastName = data["first_name"] as? String
        self.email = data["email_address"] as? String
        self.phone = data["phone"] as? String
        self.dob = data["dob"] as? [Int]
        self.ssnLast4 = data["ssnLast4"] as? String
        self.ssn = data["ssn"] as? String
        self.imageURL = data["imageURL"] as? String
        self.thumbnailsURL = data["thumbnailsURL"] as? [String]
        self.description = data["description"] as? String
        self.ip = data["ip"] as? String
     }
}

class Menu {
    
    let id: String!
    let imageURL: String!
    let name: String!
    let description: String?
    let price: Double!
    let total: Double?
    let quantity: Int?
    
    init(key: String, data: [String: Any]) {
        self.id = key
        self.imageURL = data["imageURL"] as? String
        self.name = data["name"] as? String
        self.description = data["description"] as? String
        self.price = data["price"] as? Double
        self.total = data["total"] as? Double
        self.quantity = data["quantity"] as? Int
    }
}

extension Menu: Equatable {
    
    static func == (lhs: Menu, rhs: Menu) -> Bool {
        lhs.id == rhs.id
    }
}



extension Menu: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        id as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? Menu else { return false }
        return self.id != object.id
    }
}

extension Chef: Hashable, Equatable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Chef, rhs: Chef) -> Bool {
        lhs.id == rhs.id
    }
}

extension Chef: ListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        id as NSObjectProtocol
    }
    
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard self !== object else { return true }
        guard let object = object as? Chef else { return false }
        return self.id == object.id
    }
}

