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
    
    
    // User
    
    func saveUserDetails(userId: String, data: [String: Any], complete: @escaping (Bool, Error?) -> Void) {
        self.RefCustomers.document(userId).setData(data, merge: true) { (error) in
            if let error = error {
                print("Error saving user details: ", error)
                complete(false, error)
            } else {
                complete(true, nil)
            }
        }
    }
    
    func updateUserLocation(line1: String, postalCode: String, state: String) {
        
    }
    
    func fetchUser(userId: String, complete: @escaping (User?, Error?) -> Void) {
        self.RefCustomers.document(userId).getDocument { (snapshot, error) in
            if let error = error {
                print("Error fetch user details: ", error)
                complete(nil, error)
            } else {
                guard let snapshot = snapshot else { return }
                let id = snapshot.documentID
                let data = snapshot.data()
                let user = User(id: id, data: data!)
                complete(user, nil)
            }
        }
    }
    
    
    // Payments
    
    func createStripePaymentMethod(primaryCard: String, cardNumber: String, month: UInt, year: UInt, cvc: String, complete: @escaping (Bool, Error?) -> Void) {
        
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
                self.addPaymentMethod(primaryCard: primaryCard, tokenId: method!.stripeId, number: cardNumber, cvc: cvc) { (success, error) in
                    if let error = error {
                        complete(false, error)
                    } else {
                        
                        
                        
                        
                        complete(true, nil)
                    }
                }
            }
        }
    }
    
    func addPaymentMethod(primaryCard: String, tokenId: String, number: String, cvc: String, complete: @escaping (Bool, Error?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        let ref = self.RefCustomers.document(currentUserUID).collection("payment_methods")
        ref.document(tokenId).setData(["id": tokenId, "number": number, "cvc": cvc], merge: true) { (error) in
            if let error = error {
                complete(false, error)
            } else {
                ref.document(primaryCard).updateData(["primary": false]) { (error) in
                    if let error = error {
                        complete(false, error)
                    } else {
                        complete(true, nil)
                    }
                }
            }
        }
    }
    
    func getPrimaryPaymentMethod(cardId: String, complete: @escaping (Card?, Error?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        self.RefCustomers.document(currentUserUID).collection("payment_methods").document(cardId).getDocument(completion: { (snapshot, error) in
            if let error = error {
                complete(nil, error)
            } else {
                guard let snapshot = snapshot, let data = snapshot.data() else { return }
                    if snapshot.exists {
                        let id = snapshot.documentID
                        let card = Card(id: id, data: data)
                        complete(card, error)
                }
            }
        })
    }
    
    func getPaymentMethods(complete: @escaping (Card?, Error?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        self.RefCustomers.document(currentUserUID).collection("payment_methods").getDocuments { (snapshot, error) in
            if let error = error {
                complete(nil, error)
            } else {
                for document in snapshot!.documents {
                    if document.exists {
                        let id = document.documentID
                        let data = document.data()
                        let card = Card(id: id, data: data)
                        complete(card, error)
                    }
                }
            }
        }
    }
    
    func removePaymentMethod(id: String, complete: @escaping (Bool, Error?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        self.RefCustomers.document(currentUserUID).collection("payment_methods").document(id).delete { (error) in
            if let error = error {
                complete(false, error)
            } else {
                complete(true, nil)
            }
        }
    }
    
    
    func addStripeToken() {
        
    }
    
    
    // Chefs
    func fetchChefs(id: String, complete: @escaping (Chef?, Error?) -> Void) {
        self.RefChefs.getDocuments(completion: { (snapshot, error) in
            if let error = error {
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
    
    
    func addItemToBag(bagId: String, chef: Chef, item: Menu, quantity: Int, total: Double, complete: @escaping (Bool?, Error?) -> Void) {
        
        guard let currentUserUID = Auth.auth().currentUser?.uid, let providerId = chef.id, let name = item.name, let description = item.description, let imageURL = item.imageURL else { return }
        let ref = self.RefCustomers.document(currentUserUID).collection("orders").document(bagId)
        let itemRef = ref.collection("items").document(item.id)
        Firestore.firestore().runTransaction({ (transaction, errorPointer) -> Any? in
            let document: DocumentSnapshot
            let itemDocument: DocumentSnapshot
            do {
                try document = transaction.getDocument(ref)
                try itemDocument = transaction.getDocument(itemRef)
            } catch let fetchError as NSError {
                errorPointer?.pointee = fetchError
                complete(false, fetchError)
                return nil
            }
            
            if document.exists {
                guard let totalPrice = document.data()?["total"] as? Double, let totalQuantity = document.data()?["quantity"] as? Int else {
                    return nil
                }
                transaction.updateData(["total": (total + totalPrice), "quantity":  quantity + totalQuantity], forDocument: ref)
            } else {
                transaction.setData(["total": total, "quantity": quantity], forDocument: ref)
            }
            
            if itemDocument.exists {
                guard let totalPrice = itemDocument.data()?["total"] as? Double, let totalQuantity = itemDocument.data()?["quantity"] as? Int else {
                    return nil
                }
                transaction.updateData(["total": (total + totalPrice), "quantity":  quantity + totalQuantity], forDocument: itemRef)
            } else {
                transaction.setData(["destination": providerId, "name": name, "description": description, "total": total, "quantity": quantity, "imageURL": imageURL], forDocument: itemRef)
            }
            return nil
        }) { (object, error) in
            if let error = error {
                complete(false, error)
            } else {
                complete(true, nil)
            }
        }
    }
    
    func fetchCurrentOrder(orderId: String, complete: @escaping (Bool?, Order?, Menu?, Error?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        let ref = self.RefCustomers.document(currentUserUID).collection("orders").document(orderId)
        ref.getDocument { (snapshot, error) in
            if let error = error {
                complete(false, nil, nil, error)
            } else {
                guard let snapshot = snapshot, let data = snapshot.data() else {
                    complete(false, nil, nil, error)
                    return
                }
                let documentId =  snapshot.documentID
                let order = Order(key: documentId, data: data)
                ref.collection("items").getDocuments { (snapshot, error) in
                    if let error = error {
                        complete(false, nil, nil, error)
                    } else {
                        for document in snapshot!.documents {
                            let documentId =  document.documentID
                            let data = document.data()
                            let menu = Menu(key: documentId, data: data)
                            complete(true, order, menu, nil)
                        }
                    }
                }
            }
        }
    }

    
    func placeOrder(chef: Chef, order: Order, card: Card, complete: @escaping (Bool?, Error?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid, let orderId = order.id else { return }
        let ref = self.RefCustomers.document(currentUserUID).collection("orders").document(orderId)
        ref.getDocument { (snapshot, error) in
            guard let snapshot = snapshot, let bagData = snapshot.data() else { return }
            let amount = bagData["total"] as! Double
            self.completeCharge(destination: chef.id!, amount: amount, card: card) { (success, id, error) in
                if let error = error {
                    print("Error: ", error)
                } else {
                    complete(true, nil)
                }
            }
        }
    }
    
    // Create stripe Payment token
    func completeCharge(destination: String, amount: Double, card: Card?, complete: @escaping (Bool, String?, Error?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid, let number = card?.cardNumber, let month = card?.month, let year = card?.year, let cvv = card?.cvv else { return }
        
        let cardParams = STPCardParams()
        cardParams.number =  number
        cardParams.expMonth = month
        cardParams.expYear = year
        cardParams.cvc = cvv
        
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                complete(false, nil, error)
                return
            }
            self.RefCustomers.document(currentUserUID).collection("payments").document(token.tokenId).setData(["amount": amount, "currency" : "usd", "payment_method": token.tokenId, "destination": destination], merge: true) { (error) in
                if let error = error {
                    complete(false, nil, error)
                } else {
                    complete(true, token.tokenId, nil)
                }
            }
        }
    }
    
    func fetchOrders(complete: @escaping (Order?, Error?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        self.RefCustomers.document(currentUserUID).collection("orders").getDocuments { (snapshot, error) in
            if let error = error {
                complete(nil, error)
            } else {
                for document in snapshot!.documents {
                    let id = document.documentID
                    let data = document.data()
                    let order = Order(key: id, data: data)
                    complete(order, nil)
                }
            }
        }
    }
}
