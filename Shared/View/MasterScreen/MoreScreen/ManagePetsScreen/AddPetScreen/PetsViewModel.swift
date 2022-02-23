import Foundation
import Combine
import FirebaseFirestore
import Firebase

class PetsViewModel: ObservableObject {
    @Published var pets = [PetDetails]()
    
    private var db = Firestore.firestore()
    private var listenerRegistration: ListenerRegistration?
    
    deinit {
        unsubscribe()
    }
    
    func unsubscribe() {
        if listenerRegistration != nil {
            listenerRegistration?.remove()
            listenerRegistration = nil
        }
    }
    
    func subscribe() {
        let uid = Auth.auth().currentUser?.uid
        
        db.collection("pets")
            .whereField("uid", isEqualTo: uid as Any)
            .getDocuments { snapshot, error in
            if error == nil {
                if let snapshot = snapshot {
                    DispatchQueue.main.async {
                        self.pets = snapshot.documents.map { pet in

                            let name = pet["name"] as? String ?? ""
                            let age = pet["age"] as? String ?? ""
                            let gender = pet["gender"] as? String ?? ""
                            let type = pet["type"] as? String ?? ""
                            let breed = pet["breed"] as? String ?? ""
                            let imageURL = pet["imageURL"] as? String ?? ""
                            let about = pet["about"] as? String ?? ""
                            let isFavorite = pet["isFavorite"] as? Bool ?? false

                            return PetDetails(id: pet.documentID, name: name, age: age, gender: gender, type: type, breed: breed, imageURL: imageURL, about: about, isFavorite: isFavorite)
                        }
                    }
                }
            }
            else {
                // Handle the error
            }
        }
    }
    
    func deletePets(atOffsets indexSet: IndexSet) {
        let pets = indexSet.lazy.map { self.pets[$0] }
        pets.forEach { pet in
            if let petID = pet.id {
                db.collection("pets").document(petID).delete { error in
                    if let error = error {
                        print("Unable to remove pet: \(error.localizedDescription)")
                        self.subscribe()
                    }
                }
            }
        }
    }
}
