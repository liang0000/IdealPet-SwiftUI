import SwiftUI
import SDWebImageSwiftUI

struct ManagePetsDetailScreen: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @State var showEditScreen = false
    var pet : PetDetails
    
    var body: some View {
        Form {
            Section(header: Text("Pet Image")){
                VStack {
                    AnimatedImage(url: URL(string: pet.imageURL)!)
                        .resizable()
                        .frame(height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 7)
                }
                .padding()
                .frame(width: 310)
            }
            
            Section(header: Text("Pet Profile")) {
                HStack{
                    Text("Name")
                        .frame(width: 80, alignment: .leading)
                    Text(pet.name)
                }
                
                HStack{
                    Text("Age")
                        .frame(width: 80, alignment: .leading)
                    Text("\(pet.age) months old")
                }
                
                HStack{
                    Text("Gender")
                        .frame(width: 80, alignment: .leading)
                    Text(pet.gender)
                }
                
                HStack{
                    Text("Type")
                        .frame(width: 80, alignment: .leading)
                    Text(pet.type)
                }
                
                HStack{
                    Text("Breed")
                        .frame(width: 80, alignment: .leading)
                    Text(pet.breed)
                }
            }
            
            Section(header: Text("About Pet")){
                Text(pet.about)
                    .frame(minHeight: 60)
            }
        }
        .navigationTitle(pet.name)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {showEditScreen.toggle()}) { Text("Edit") })
        .sheet(isPresented: $showEditScreen) {
            EditAddPetScreen(vm: PetViewModelImpl(service: PetServiceImpl(), details: pet), mode: .edit)
        }
    }
}

struct ManagePetsDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        ManagePetsDetailScreen(pet: PetDetails(name: "Nina", age: "23", gender: "Male", type: "Dog", breed: "Corgi", imageURL: "https://firebasestorage.googleapis.com/v0/b/shoppal-67b0a.appspot.com/o/Product_Image1628645033516.jpg?alt=media&token=45fcb14b-ee95-495b-8eab-b8f566f39d2b", about: "iloveyou", isFavorite: false))
    }
}
