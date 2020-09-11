//
//  DataService.swift
//  Lidora
//
//  Created by Kerby Jean on 9/9/20.
//


import Stripe
import FirebaseAuth
import FirebaseFirestore

class DataService {
    
    static let shared = DataService()
    
    // MARK: - Firebase Refs
    
    var RefCustomers: CollectionReference {
        return Firestore.firestore().collection("customers")
    }
    
    var RefChefs: CollectionReference {
        return Firestore.firestore().collection("chefs")
    }
    
    
    // Payments
    
    func getStripeToken(cardNumber: String, month: UInt, year: UInt, cvc: String, complete: @escaping (Bool, Error?) -> Void) {
        
        let cardParams = STPCardParams()
        cardParams.name = "Kerby Jean"
        cardParams.number = cardNumber
        cardParams.expMonth =  month
        cardParams.expYear = year
        cardParams.cvc = cvc
        cardParams.address.postalCode = "33161"
        
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
        //        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        self.RefCustomers.document("Ramd0v1wEIboP9HIgmtdxfYSeA13").collection("payment_methods").document(tokenId).setData(["id": tokenId], merge: true) { (error) in
            if let error = error {
                complete(false, error)
            } else {
                complete(true, nil)
            }
        }
    }
    
    func getPaymentMethods(complete: @escaping (Card?, Error?) -> Void) {
        //        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        
        self.RefCustomers.document("Ramd0v1wEIboP9HIgmtdxfYSeA13").collection("payment_methods").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error: ", error)
                complete(nil, error)
            } else {
                for document in snapshot!.documents {
                    let id = document.documentID
                    let data = document.data()
                    let card = Card(id: id, data: data)
                    complete(card, error)
                }
            }
        }
    }
    
    func removePaymentMethod(id: String, complete: @escaping (Bool, Error?) -> Void) {
        self.RefCustomers.document("Ramd0v1wEIboP9HIgmtdxfYSeA13").collection("payment_methods").document(id).delete { (error) in
            if let error = error {
                complete(false, error)
            } else {
                complete(true, nil)
            }
        }
    }
    
    // Chefs
    
    func fetchChefs(id: String, complete: @escaping (Chef?, Error?) -> Void) {
        self.RefChefs.getDocuments(completion: { (snapshot, error) in
            if let error = error {
                print("Error fetching chefs: ", error)
                complete(nil, error)
            } else {

                for document in snapshot!.documents {
                    let id = document.documentID
                    let data = document.data()
                    let chef = Chef(key: id, data: data)
                    complete(chef, nil)
                }
            }
        })
    }
    
    func fetchMenu(id: String, complete: @escaping (Menu?, Error?) -> Void) {
        self.RefChefs.document(id).collection("menu").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching menu: ", error)
                complete(nil, error)
            } else {
                for document in snapshot!.documents {
                    let id = document.documentID
                    let data = document.data()
                    let menu = Menu(key: id, data: data)
                    complete(menu, nil)
                }
            }
        }
    }
}
