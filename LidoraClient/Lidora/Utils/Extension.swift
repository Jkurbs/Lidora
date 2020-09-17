//
//  Extension.swift
//  Lidora
//
//  Created by Kerby Jean on 9/14/20.
//

import UIKit 

// Return UIView Id
extension UIView {
    static var id: String {
        String(describing: self)
    }
}

extension String {
    static var userId = "UserID"
    static var bagId = "BagID"
}

extension NSNotification.Name {
    static let addToBag = NSNotification.Name("addToBag")
}
