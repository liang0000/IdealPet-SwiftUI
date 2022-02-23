import Combine
import Foundation
import FirebaseAuth

protocol SignInService {
    //return a publisher that we can subcribe and if success then return Void
    func signIn(with credentials: SignInCredentials) -> AnyPublisher<Void, Error>
}

final class SignInServiceImpl: SignInService {
    func signIn(with credentials: SignInCredentials) -> AnyPublisher<Void, Error> {
        
        Deferred{
            Future { promise in
                Auth
                    .auth()
                    .signIn(withEmail: credentials.email, password: credentials.password) { res, error in
                        if let err = error {
                            promise(.failure(err))
                        } else {
                            promise(.success(()))
                        }
                    }
            }
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }
    
}
