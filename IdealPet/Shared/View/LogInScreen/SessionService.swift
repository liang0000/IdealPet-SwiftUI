import Combine
import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

enum SessionState {
    case loggedIn
    case loggedOut
}

protocol SessionService {
    var state: SessionState { get }
    var userDetails: SessionUserDetails? { get }
    func logOut()
}

final class SessionServiceImpl: ObservableObject, SessionService {
    @Published var state: SessionState = .loggedOut
    @Published var userDetails: SessionUserDetails?
    
    private var handler: AuthStateDidChangeListenerHandle?
    init() {
        setupFirebaseAuthHandler()
    }
    
    func logOut() {
        try? Auth.auth().signOut()
    }
}

private extension SessionServiceImpl {
    func setupFirebaseAuthHandler() {
        handler = Auth
            .auth()
            .addStateDidChangeListener{[weak self] res, user in
                guard let self = self else {return}
                self.state = user == nil ? .loggedOut : .loggedIn
                if let uid = user?.uid {
                    self.handlerRefresh(with: uid)
                }
            }
    }
    
    func handlerRefresh(with uid: String){
//        Database
//            .database()
//            .reference()
//            .child("users")
//            .child(uid)
//            .observe(.value) {[weak self] snapshot in
//                guard let self = self,
//                      let value = snapshot.value as? NSDictionary,
//                      let name = value[SignUpKeys.name.rawValue] as? String,
//                      let phoneNum = value[SignUpKeys.phoneNum.rawValue] as? String,
//                      let email = value[SignUpKeys.email.rawValue] as? String,
//                      let password = value[SignUpKeys.password.rawValue] as? String else {
//                          return
//                }
//
//                DispatchQueue.main.async{
//                    self.userDetails = SessionUserDetails(name: name, phoneNum: phoneNum, email: email, password: password)
//                }
//            }
        
        Firestore
            .firestore()
            .collection("users")
            .document(uid)
            .getDocument { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        let name = snapshot.get("name") as? String ?? ""
                        let email = snapshot.get("email") as? String ?? ""
                        let phoneNum = snapshot.get("phoneNum") as? String ?? ""
                        let password = snapshot.get("password") as? String ?? ""
                        
                        self.userDetails = SessionUserDetails(name: name, phoneNum: phoneNum, email: email, password: password)
                    }
                }
            }
            else {
                // Handle the error
            }
        }
    }
}
