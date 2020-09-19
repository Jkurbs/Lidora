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
    
    init(id: String, data: [String: Any]) {
        self.id = id
        self.orderId = data["order_id"] as? String
        self.firstName = data["first_name"] as? String
        self.lastName = data["last_name"] as? String
        self.email = data["email"] as? String
        self.phoneNumber = data["phone"] as? String
        self.primaryCard = data["primary_card"] as? String
    }
}
