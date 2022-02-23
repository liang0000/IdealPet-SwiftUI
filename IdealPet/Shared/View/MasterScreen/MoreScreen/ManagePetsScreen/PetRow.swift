import SwiftUI
import SDWebImageSwiftUI

struct PetRow: View {
    
    var pet: PetDetails
    
    var body: some View {
            HStack {
                AnimatedImage(url: URL(string: pet.imageURL)!)
                    .resizable()
                    .frame(width: 55, height: 55)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.black, lineWidth: 2))
                
                VStack(alignment: .leading) {
                    Text(pet.name)
                        .fontWeight(.bold)
                    Text(pet.age + " months old")
                }
                .padding(.leading, 10)
                Spacer()
            }
            .padding(10)
    }
}

struct PetRow_Previews: PreviewProvider {
    static var previews: some View {
        PetRow(pet: PetDetails(name: "Nina", age: "23", gender: "", type: "", breed: "", imageURL: "https://firebasestorage.googleapis.com/v0/b/shoppal-67b0a.appspot.com/o/Product_Image1628645033516.jpg?alt=media&token=45fcb14b-ee95-495b-8eab-b8f566f39d2b", about: "", isFavorite: false))
    }
}
