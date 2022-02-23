import Foundation
import Combine

enum ForgotPasswordState {
    case successful
    case failed(error: Error)
    case na
}

protocol ForgotPasswordViewModel {
    //handle sign up
    func sendPasswordReset()
    
    //for injecting and using our service
    var service: ForgotPasswordService { get }
    
    var email: String { get }
    
    var state: ForgotPasswordState { get }
    var hasError: Bool { get }
    
    //property to bind text field input to viewmodel
    init(service: ForgotPasswordService)
}

final class ForgotPasswordViewModelImpl: ObservableObject, ForgotPasswordViewModel {
    
    var service: ForgotPasswordService
    @Published var email: String = ""
    
    @Published var state: ForgotPasswordState = .na
    @Published var hasError: Bool = false
    private var subscriptions = Set<AnyCancellable>()
    init(service: ForgotPasswordService){
        self.service = service
        setupErrorSubscriptions()
    }
    
    func sendPasswordReset() {
        service
            .sendPasswordReset(to: email)
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

private extension ForgotPasswordViewModelImpl{
    func setupErrorSubscriptions() {
        $state
            .map { state -> Bool in
                switch state {
                case .na:
                    return false
                case .successful:
                    return true
                case .failed:
                    return true
                }
            }
            .assign(to: &$hasError)
    }
}

