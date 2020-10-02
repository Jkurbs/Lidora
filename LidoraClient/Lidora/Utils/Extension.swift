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

public func roundNumber(_ value: Double) -> Double {
  let divisor = pow(10.0, Double(2))
  return round(value * divisor) / divisor
}

public func percentage(value:Double, percentageVal:Double, additional: Double?)->Double{
    let val = (value * percentageVal)
    if let additional = additional {
        return (val / 100.0) + additional
    } else {
        return (val / 100.0)
    }
}

extension Double {

    func serviceFee() -> (subtotal: Double, stripeFee: Double, platformFee: Double, serviceFee: Double, deliveryFee: Double, total: Double) {
        let subtotal = roundNumber(self)
        let stripeFee = roundNumber(percentage(value: subtotal, percentageVal: 2.9, additional: 0.30))
        let platformFee = roundNumber(percentage(value: subtotal, percentageVal: 10, additional: nil))
        let serviceFee = roundNumber(stripeFee + platformFee)
        let deliveryFee = 0.30
        let total = roundNumber(subtotal + stripeFee + platformFee + deliveryFee)
        return (subtotal: subtotal, stripeFee: stripeFee, platformFee: platformFee, serviceFee: serviceFee, deliveryFee: deliveryFee, total: total)
    }
}



extension NSNotification.Name {
    static let addToBag = NSNotification.Name("addToBag")
}


