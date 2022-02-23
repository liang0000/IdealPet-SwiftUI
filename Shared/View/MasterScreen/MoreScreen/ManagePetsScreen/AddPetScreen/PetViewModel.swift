import Foundation
import Combine

enum AddPetState {
    case successful
    case failed(error: Error)
    case na
}

enum Mode {
    case add, edit
}

enum Action {
    case done, delete, cancel
}

protocol PetViewModel {
    
    func addOrEditPet()
    var service: PetService { get }
    var state: AddPetState { get }
    var petDetails: PetDetails { get }
    var hasError: Bool { get }
    init(service: PetService, details: PetDetails)
}

final class PetViewModelImpl: ObservableObject, PetViewModel {
    let breed : [String : [String]] = ["Dog": dogTypes,
                                       "Cat": catTypes,
                                       "Hamster": hamsterTypes,
                                       "Rabbit": rabbitTypes,
                                       "Bird": birdTypes,
                                       "Other": otherTypes]
    var breedList : [String] {
        breed[petDetails.type] ?? []
    }
    @Published var confirmDelete: Bool = false
    @Published var showImagePicker: Bool = false
    var completionHandler: ((Result<Action, Error>) -> Void)?
    
    let service: PetService
    @Published var state: AddPetState = .na
    @Published var petDetails: PetDetails = PetDetails.new
    @Published var hasError: Bool = false
    private var subscriptions = Set<AnyCancellable>()
    init(service: PetService, details: PetDetails) {
        self.service = service
        self.petDetails = details
        setupErrorSubscriptions()
    }
    
    func addOrEditPet() {
        service
            .addOrEditPet(with: petDetails)
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
    
    func deletePet() {
        service.deletePet(with: petDetails)
    }
}

private extension PetViewModelImpl{
    
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
