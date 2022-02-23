import Combine
import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase

protocol AccountService {
    func updateAccount(with details: AccountDetails) -> AnyPublisher<Void, Error>
    func logOut()
}

final class AccountServiceImpl: AccountService {
    
    func updateAccount(with details: AccountDetails) -> AnyPublisher<Void, Error> {
        Deferred {
            Future { promise in
                Auth.auth().currentUser?.updateEmail(to: details.email) { error in
                    if let err = error {
                        promise(.failure(err))
                    } else {
                        promise(.success(()))
                        
                        Auth.auth().currentUser?.updatePassword(to: details.password) { error in
                            if let err = error {
                                promise(.failure(err))
                            } else {
                                promise(.success(()))
                                
                                if let uid = Auth.auth().currentUser?.uid {
                                    let values = [SignUpKeys.name.rawValue: details.name,
                                                  SignUpKeys.phoneNum.rawValue: details.phoneNum,
                                                  SignUpKeys.email.rawValue: details.email,
                                                  SignUpKeys.password.rawValue: details.password] as [String : Any]
                                    
                                    Firestore
                                        .firestore()
                                        .collection("users")
                                        .document(uid)
                                        .setData(values) {error in
                                            if let err = error {
                                                promise(.failure(err))
                                            } else {
                                                promise(.success(()))
                                            }
                                        }
                                } else {
                                    promise(.failure(NSError(domain: "Invalid User ID", code: 0, userInfo: nil)))
                                }
                            }
                        }
                    }
                }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
    func logOut() {
        try? Auth.auth().signOut()
    }
    
}
