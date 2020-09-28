//
//  Delegate.swift
//  Lidora
//
//  Created by Kerby Jean on 9/20/20.
//

import Foundation


protocol CardDelegate {
    func switchCard(newCard: Card)
}

protocol LocationDelegate {
    func location(line1: String, postalCode: String, city: String, state: String)
}
