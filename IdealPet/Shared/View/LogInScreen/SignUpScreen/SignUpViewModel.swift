import Foundation
import Combine

enum SignUpState {
    case successful
    case failed(error: Error)
    case na
}

protocol SignUpViewModel {
    //handle sign up
    func signUp()
    
    //for injecting and using our service
    var service: SignUpService { get }
    
    //property to handle state changes
    var state: SignUpState { get }
    
    //property to bind text field input to viewmodel
    var userDetails: SignUpDetails { get }
    var hasError: Bool { get }
    var errorMessage: String { get }
    init(service: SignUpService)
}

final class SignUpViewModelImpl: ObservableObject, SignUpViewModel {
    
    let service: SignUpService
    @Published var state: SignUpState = .na
    var userDetails: SignUpDetails = SignUpDetails.new
    @Published var hasError: Bool = false
    @Published var errorMessage: String = ""
    private var subscriptions = Set<AnyCancellable>()
    init(service: SignUpService) {
        self.service = service
        setupErrorSubscriptions()
    }
    
    func signUp() {
        if userDetails.name == "" {
            hasError = true
            errorMessage = "A name must be provided."
            return
        } else if userDetails.phoneNum == "" {
            hasError = true
            errorMessage = "A phone number must be provided."
            return
        } else {
            service
                .signUp(with: userDetails)
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
}

private extension SignUpViewModelImpl{
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
