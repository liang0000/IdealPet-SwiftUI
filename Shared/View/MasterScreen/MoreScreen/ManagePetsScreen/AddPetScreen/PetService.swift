import Combine
import Foundation
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import FirebaseStorage

enum AddPetKeys: String {
    case name, age, gender, type, breed, imageURL, about, datePosted, isFavorite, uid
}

protocol PetService {
    func addOrEditPet(with details: PetDetails) -> AnyPublisher<Void, Error>
    func deletePet(with details: PetDetails)
}

final class PetServiceImpl: PetService {
    func addOrEditPet(with details: PetDetails) -> AnyPublisher<Void, Error> {
        Deferred{
            Future { promise in
                //store image to storage
                guard let uid = Auth.auth().currentUser?.uid else {
                    print("Dont have any UID")
                    return
                }
                
                guard let imageData = details.image?.jpegData(compressionQuality: 0.7) else {
                    print("Image not found")
                    return
                }
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpg"
                
                let ref = Storage.storage().reference(withPath: "\(uid)/\(imageData)")
                ref.putData(imageData, metadata: metaData) { metadata, err in
                    if let err = err {
                        promise(.failure(err))
                    }
                    
                    ref.downloadURL { url, err in
                        if let err = err {
                            promise(.failure(err))
                        }
                        
                        guard let urlString = url else {
                            print("ImageURL not found")
                            return
                        }
                        
                        let values = [AddPetKeys.imageURL.rawValue: urlString.absoluteString,
                                      AddPetKeys.name.rawValue: details.name,
                                      AddPetKeys.age.rawValue: details.age,
                                      AddPetKeys.gender.rawValue: details.gender,
                                      AddPetKeys.type.rawValue: details.type,
                                      AddPetKeys.breed.rawValue: details.breed,
                                      AddPetKeys.about.rawValue: details.about,
                                      //                                      AddPetKeys.datePosted.rawValue: details.datePosted,
                                      AddPetKeys.isFavorite.rawValue: details.isFavorite,
                                      AddPetKeys.uid.rawValue: uid] as [String : Any]
                        
                        if let petID = details.id {
                            Firestore
                                .firestore()
                                .collection("pets")
                                .document(petID)
                                .setData(values, merge: false) {error in
                                    if error == nil {
                                        DispatchQueue.main.async {
                                            let getData = PetsViewModel()
                                            getData.subscribe()
                                        }
                                    }
                                }
                        }else {
                            var ref: DocumentReference? = nil
                            ref = Firestore
                                .firestore()
                                .collection("pets")
                                .addDocument(data: values) {error in
                                    if error == nil {
                                        DispatchQueue.main.async {
                                            let getData = PetsViewModel()
                                            getData.subscribe()
                                            print("Pet ID: \(ref!.documentID)")
                                        }
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
    
    func deletePet(with details: PetDetails) {
        if let petID = details.id {
            Firestore.firestore().collection("pets").document(petID).delete { error in
                
                if error == nil {
                    DispatchQueue.main.async {
                        let getData = PetsViewModel()
                        getData.pets.removeAll { pet in
                            return pet.id == details.id
                        }
                        getData.subscribe()
                    }
                }
            }
        }
    }
}
