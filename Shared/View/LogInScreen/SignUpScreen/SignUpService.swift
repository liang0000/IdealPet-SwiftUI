import Combine
import Foundation
import Firebase
import FirebaseDatabase
import FirebaseFirestore

enum SignUpKeys: String {
    case name, phoneNum, email, password
}

protocol SignUpService {
    //return a publisher that we can subcribe and if success then return Void
    func signUp(with details: SignUpDetails) -> AnyPublisher<Void, Error>
}

final class SignUpServiceImpl: SignUpService {
    func signUp(with details: SignUpDetails) -> AnyPublisher<Void, Error> {
        
        Deferred{
            Future { promise in
                
                Auth
                    .auth()
                    .createUser(withEmail: details.email, password: details.password) { res, error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            if let uid = res?.user.uid {
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
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
