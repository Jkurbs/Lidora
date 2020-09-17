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
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        self.RefCustomers.document(currentUserUID).collection("payment_methods").document(tokenId).setData(["id": tokenId], merge: true) { (error) in
            if let error = error {
                complete(false, error)
            } else {
                complete(true, nil)
            }
        }
    }
    
    func getPaymentMethods(complete: @escaping (Card?, Error?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        self.RefCustomers.document(currentUserUID).collection("payment_methods").getDocuments { (snapshot, error) in
            if let error = error {
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
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        self.RefCustomers.document(currentUserUID).collection("payment_methods").document(id).delete { (error) in
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
    
    
    func addItemToBag(bagId: String, item: Menu, quantity: Int, total: Double, complete: @escaping (Bool?, Error?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid, let name = item.name, let description = item.description, let imageURL = item.imageURL else { return }
        let ref = self.RefCustomers.document(currentUserUID).collection("bag").document(bagId)
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
                transaction.updateData(["total": totalPrice + total, "quantity":  quantity + totalQuantity], forDocument: ref)
            } else {
                transaction.setData(["total": total, "quantity": quantity], forDocument: ref)
            }

            if itemDocument.exists {
                guard let totalQuantity = itemDocument.data()?["quantity"] as? Int else {
                    return nil
                }
                transaction.updateData(["quantity":  quantity + totalQuantity], forDocument: itemRef)
            } else {
                transaction.setData(["name": name, "description": description, "quantity": quantity, "imageURL": imageURL], forDocument: itemRef)
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
    
    func fetchBag(bagId: String, complete: @escaping (Bool?, Bag?, Menu?, Error?) -> Void) {
        guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        let ref = self.RefCustomers.document(currentUserUID).collection("bag").document(bagId)
        ref.getDocument { (snapshot, error) in
            if let error = error {
                complete(false, nil, nil, error)
            } else {
                guard let snapshot = snapshot, let data = snapshot.data() else {
                    complete(false, nil, nil, error)
                    return
                }
                let documentId =  snapshot.documentID
                let bag = Bag(key: documentId, data: data)
                ref.collection("items").getDocuments { (snapshot, error) in
                    if let error = error {
                        complete(false, nil, nil, error)
                    } else {
                        for document in snapshot!.documents {
                            let documentId =  document.documentID
                            let data = document.data()
                            let menu = Menu(key: documentId, data: data)
                            complete(true, bag, menu, nil)
                       }
                    }
                }
            }
        }
    }
    
    
    
    
    
    func placeOrder(chef: Chef, orders: [Order], complete: @escaping (Bool?, Error?) -> Void) {
        // guard let currentUserUID = Auth.auth().currentUser?.uid else { return }
        
        let providerId = orders.map { $0.providerId}
        
        for provider in providerId {
            guard let order = orders.filter({$0.providerId == provider}).first else { return }
            let ref = self.RefCustomers.document("Ramd0v1wEIboP9HIgmtdxfYSeA13").collection("orders").document(order.id)
            ref.setData([
                "id": order.id!,
                "provider_id": order.providerId!,
                "price": order.price!,
                "quantity": order.quantity!,
            ]) { (error) in
                if let error = error {
                    print("Error: ", error)
                } else {
                    print("MENU QUANTITY: ", order.items?.count)
                    for menu in order.items! {
                        print("MENU ID: ", menu.id)
                        ref.collection("items").document(menu.id).setData(
                            [
                                
                                "imageURL": chef.imageURL,
                                "price":menu.price,
                                
                            ]) { (error) in
                            if let error = error {
                                
                            }
                        }
                        
                        //                            .collection("items").addDocument(data: ["1": menu]) { (err0r) in
                        //                            if let error = error {
                        //                                complete(false, error)
                        //                            } else {
                        //                                complete(true, nil)
                        //                            }
                        //                        }
                    }
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
