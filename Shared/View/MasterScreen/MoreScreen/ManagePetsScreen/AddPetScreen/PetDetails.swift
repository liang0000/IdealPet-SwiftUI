import Foundation
import SwiftUI
import FirebaseFirestoreSwift

struct PetDetails : Identifiable, Hashable {
    @DocumentID var id: String?
    var name: String
    var age: String
    var gender: String
    var type : String
    var breed: String
    var image: UIImage?
    var imageURL: String
    var about: String
    var isFavorite: Bool
    var uid: String?
}

extension PetDetails {
    static var new: PetDetails{
        PetDetails(name: "", age: "", gender: "", type: "", breed: "", imageURL: "", about: "", isFavorite: false)
    }
    
}


//var datePosted: Date
//var dateString: String {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .medium
//    return formatter.string(from: datePosted)
//}
