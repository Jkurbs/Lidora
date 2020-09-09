//
//  DataService.swift
//  Lidora
//
//  Created by Kerby Jean on 9/9/20.
//


import Stripe
import FirebaseFirestore

class DataService {
    
    static let shared = DataService()
    
    // MARK: - Firebase Refs
    
    var RefCustomers: CollectionReference {
        return Firestore.firestore().collection("customers")
    }
    
    func getStripeToken(cardNumber: String, month: UInt, year: UInt, cvc: String, complete: @escaping (Bool, Error?) -> Void) {

        let cardParams = STPCardParams()
        cardParams.name = "Kerby Jean"
        cardParams.number = cardNumber
        cardParams.expMonth =  month
        cardParams.expYear = year
        cardParams.cvc = cvc
        
        let params = STPPaymentMethodCardParams(cardSourceParams: cardParams)
        let paymentMethodParams = STPPaymentMethodParams(card: params, billingDetails: nil, metadata: nil)
        
        STPAPIClient.shared().createPaymentMethod(with: paymentMethodParams) { (method, error) in
            if let error = error {
                complete(false, error)
            } else {
                self.addPaymentMethod(tokenId: method!.stripeId) { (success, error) in
                    if let error = error {
                        complete(false, error)
                    } else {
                        complete(true, nil)
                    }
                }
            }
        }
    }
    
    func addPaymentMethod(tokenId: String, complete: @escaping (Bool, Error?) -> Void) {
        self.RefCustomers.document("Ramd0v1wEIboP9HIgmtdxfYSeA13").collection("payment_methods").document(tokenId).setData(["stripeId": tokenId], merge: true) { (error) in
            if let error = error {
                complete(false, error)
            } else {
                complete(true, nil)
            }
        }
    }
}
