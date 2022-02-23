import Combine
import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase

enum UpdateAccountState {
    case successful
    case failed(error: Error)
    case na
}

enum AccountState {
    case loggedIn
    case loggedOut
}

protocol AccountViewModel {
    var service: AccountService { get }
    var state: UpdateAccountState { get }
    var accState: AccountState { get }
    var accountDetails: AccountDetails { get }
    var hasError: Bool { get }
    func logOut()
    func updateAccount()
    init(service: AccountService)
}

final class AccountViewModelImpl: ObservableObject, AccountViewModel {
    let service: AccountService
    @Published var state: UpdateAccountState = .na
    @Published var accState: AccountState = .loggedOut
    @Published var accountDetails: AccountDetails = AccountDetails.new
    @Published var hasError: Bool = false
    private var subscriptions = Set<AnyCancellable>()
    private var handler: AuthStateDidChangeListenerHandle?
    init(service: AccountService) {
        self.service = service
        setupFirebaseAuthHandler()
        setupErrorSubscriptions()
    }
    
    func logOut() {
        service.logOut()
    }
    
    func updateAccount() {
        service
            .updateAccount(with: accountDetails)
            .sink{ [weak self] res in
                switch res{
                case .failure(let error):
                    self?.state = .failed(error: error)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successful
            }
            .store(in: &subscriptions)
    }
}

private extension AccountViewModelImpl {
    func setupFirebaseAuthHandler() {
        handler = Auth
            .auth()
            .addStateDidChangeListener{[weak self] res, user in
                guard let self = self else {return}
                self.accState = user == nil ? .loggedOut : .loggedIn
                if let uid = user?.uid {
                    self.handlerRefresh(with: uid)
                }
            }
    }
    
    func handlerRefresh(with uid: String){
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
                        self.accountDetails = AccountDetails(name: name, phoneNum: phoneNum, email: email, password: password)
                    }
                }
            }
            else {
                // Handle the error
            }
        }
    }
    
    func setupErrorSubscriptions() {
        $state
            .map { state -> Bool in
                switch state {
                case .successful,
                        .na:
                    return false
                case .failed:
                    return true
                }
            }
            .assign(to: &$hasError)
    }
}
