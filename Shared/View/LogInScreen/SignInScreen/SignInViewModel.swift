import Foundation
import Combine

enum SignInState {
    case successful
    case failed(error: Error)
    case na
}

protocol SignInViewModel {
    //handle sign in
    func signIn()
    
    //for our service that we r going to inject
    var service: SignInService { get }
    
    //listen to when a logging was successful
    var state: SignInState { get }
    
    //hold the data when those textfield was typed in
    var credentials: SignInCredentials { get }
    var hasError: Bool { get }
    init(service: SignInService)
}

final class SignInViewModelImpl: ObservableObject, SignInViewModel {
    
    let service: SignInService
    @Published var state: SignInState = .na
    @Published var credentials: SignInCredentials = SignInCredentials.new
    @Published var hasError: Bool = false
    private var subscriptions = Set<AnyCancellable>()
    init(service: SignInService) {
        self.service = service
        setupErrorSubscriptions()
    }
    
    func signIn() {
        service
            .signIn(with: credentials)
            .sink{ res in
                switch res{
                case .failure(let error):
                    self.state = .failed(error: error)
                default: break
                }
            } receiveValue: { [weak self] in
                self?.state = .successful
            }
            .store(in: &subscriptions)
    }
}

private extension SignInViewModelImpl{
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
