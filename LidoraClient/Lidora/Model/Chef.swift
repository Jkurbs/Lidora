//
//  Chef.swift
//  Lidora
//
//  Created by Kerby Jean on 9/6/20.
//

import Foundation

struct Chef {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let dob: [String]
    let ssnLast4: String
    let ssn: String
    let address: Address
    let ip: String
    let menu: Menu
}

struct Address {
    let city: String
    let line1: String
    let postalCode: String
    let state: String
}

struct Menu {
    var items: [Items]
}

struct Items {
    let name: String
    let description: String?
    let price: Int
    let quantity: Int 
}

extension Chef: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Chef, rhs: Chef) -> Bool {
        lhs.id == rhs.id
    }
}
