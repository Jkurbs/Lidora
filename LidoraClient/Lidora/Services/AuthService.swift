//
//  AuthService.swift
//  Lidora
//
//  Created by Kerby Jean on 9/15/20.
//

import FirebaseAuth

class AuthService {
    
    static let shared = AuthService()
    
    var UserID: String? {
        didSet {
            //UserDefaults.standard.set(UserID, forKey: .userId)
        }
    }
    
    // MARK: - Phone verification
    
    func PhoneAuth(phone: String, complete: @escaping (Bool, Error?) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { verificationID, error in
            if let error = error {
                print("ERROR:", error.localizedDescription)
                complete(false, error)
                return
            } else {
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                complete(true, nil)
            }
        }
    }
    
    // MARK: Email register
    
    func EmailAuth(username: String, name: String, email: String, phone: String, pwd: String, code: String, complete: @escaping (Bool, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: pwd) { result, error in
            if let error = error {
                print("ERROR:", error.localizedDescription)
                complete(false, error)
            } else {
                if let user = result?.user {
                    
                    /// Link email with phone credential
                    
                    let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "authVerificationID")!, verificationCode: code)
                    
                    user.link(with: credential, completion: { _, error in
                        if let err = error {
                            print("Error:", err.localizedDescription)
                        } else {
                            UserDefaults.standard.set(user.uid, forKey: "userId")
                            UserDefaults.standard.synchronize()
                            let changeRequest = user.createProfileChangeRequest()
                            changeRequest.displayName = name
                            changeRequest.commitChanges { error in
                                print("ERROR:", error?.localizedDescription ?? "")
                                let data: [String: Any] = ["email": email, "name": name, "username": username]

                            }
                        }
                    })
                }
            }
        }
    }
    
    // MARK: - Email login
    
    func emailLogin(email: String, pwd: String, complete: @escaping (String?, User?, Bool, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pwd) { result, error in
            if let error = error {
                complete(nil, nil, false, error)
            } else {
                if let uid = result?.user.uid {
                    self.UserID = uid
                    DataService.shared.fetchUser(userId: uid) { (user, error) in
                        if let error = error {
                            print("Error fetching user details: ", error)
                        } else {
                            complete(uid, user, true, nil)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Phone login
    
    func phoneLogIn(code: String, complete: @escaping (Bool, Error?, String?) -> Void) {
        let defaults = UserDefaults.standard
        let credential: PhoneAuthCredential = PhoneAuthProvider.provider().credential(withVerificationID: defaults.string(forKey: "authVerificationID")!, verificationCode: code)
        Auth.auth().signIn(with: credential) { result, error in
            if let err = error {
                print(err)
                complete(false, error, nil)
                return
            } else {
                if let user = result?.user {
                    complete(true, nil, user.uid)
                }
            }
        }
    }
    
    
    // MARK: - Create account
    
    func createAccount(firstName: String, lastName: String?, username: String, email: String, pwd: String, complete: @escaping (Bool, Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: pwd) { result, error in
            if let error = error {
                NSLog("Error creating user: \(error)")
                complete(false, error)
                return
            } else {
                if let user = result?.user {
                    print("USERID: \(user.uid)")
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = "\(firstName) \(lastName ?? "")"
                    changeRequest.commitChanges { error in
                        let data: [String: Any] = ["email": email, "firstName": firstName, "lastName": firstName, "username": username]
                        DataService.shared.saveUserDetails(userId: user.uid, data: data) { (success, error) in
                            if !success {
                                complete(false, error)
                            } else {
                                complete(true, nil)
                            }
                        }
                    }
                }
            }
        }
    }
}
