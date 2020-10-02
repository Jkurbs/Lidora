//
//  User.swift
//  Lidora
//
//  Created by Kerby Jean on 9/9/20.
//

import Foundation

struct User {
    let id: String?
    let orderId: String?
    let firstName: String?
    let lastName: String?
    let email: String?
    let phoneNumber: String?
    let primaryCard: String?
    let line1: String?
    let state: String?
    let city: String?
    let postalCode: String?
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.orderId = data["order_id"] as? String
        self.firstName = data["first_name"] as? String
        self.lastName = data["last_name"] as? String
        self.email = data["email"] as? String
        self.phoneNumber = data["phone"] as? String
        self.primaryCard = data["primary_card"] as? String
        self.line1 = data["line1"] as? String
        self.state = data["state"] as? String
        self.city = data["city"] as? String
        self.postalCode = data["postal_code"] as? String
    }
}
