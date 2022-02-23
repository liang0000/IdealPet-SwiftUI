import SwiftUI
import Combine
import SDWebImageSwiftUI

struct EditAddPetScreen: View {
    
    @StateObject var vm = PetViewModelImpl(service: PetServiceImpl(), details: PetDetails.new)
    @Environment(\.presentationMode) private var presentationMode
    var mode: Mode = .add
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Pet Image")){
                    HStack{
                        Button(action: {
                            vm.showImagePicker.toggle()
                        }) {
                            if let image = vm.petDetails.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .shadow(radius: 7)
                            }
                            else if let _ = vm.petDetails.id {
                                AnimatedImage(url: URL(string: vm.petDetails.imageURL))
                                    .resizable()
                                    .frame(height: 100)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .shadow(radius: 7)
                            }
                            else {
                                Image(systemName: "pawprint.fill")
                                    .font(.system(size: 54))
                                    .padding()
                                    .foregroundColor(Color(.label))
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .shadow(radius: 7)
                            }
                        }
                    }
                    .padding()
                    .frame(width: 310)
                }
                
                Section(header: Text("Pet Profile")) {
                    HStack{
                        Text("Name")
                            .frame(width: 80, alignment: .leading)
                        TextField("please enter name", text: $vm.petDetails.name)
                    }
                    
                    HStack{
                        Text("Age")
                            .frame(width: 80, alignment: .leading)
                        TextField("in months", text: $vm.petDetails.age)
                            .keyboardType(.numberPad)
                            .onReceive(Just(vm.petDetails.age)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    vm.petDetails.age = filtered
                                }
                            }
                    }
                    
                    Picker("Gender", selection: $vm.petDetails.gender) {
                        ForEach(gender, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Picker("Type", selection: $vm.petDetails.type) {
                        ForEach(petTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    
                    Picker("Breed", selection: $vm.petDetails.breed) {
                        ForEach(vm.breedList, id: \.self) {
                            Text($0)
                                .tag($0 as String?)
                        }
                    }
                }
                
                Section(header: Text("About Pet"),
                        footer: Text("E.g. purpose of post, health, traits, color, personality, current location, etc")) {
                    TextEditor(text: $vm.petDetails.about)
                        .frame(minHeight: 60)
                }
                
                if mode == .edit {
                    Section {
                        Button("Delete Pet") { vm.confirmDelete.toggle() }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle(mode == .add ? "Add Pet" : vm.petDetails.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                },
                trailing: Button(action: {
                    vm.addOrEditPet()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text(mode == .add ? "Done" : "Save")
                }
                    .disabled(vm.petDetails.name.isEmpty || vm.petDetails.age.isEmpty ||
                              vm.petDetails.gender.isEmpty || vm.petDetails.type.isEmpty ||
                              vm.petDetails.breed.isEmpty || vm.petDetails.about.isEmpty ||
                              vm.petDetails.image == nil)
            )
            .actionSheet(isPresented: $vm.confirmDelete) {
                ActionSheet(title: Text("Confirm Delete"),
                            buttons: [
                                .destructive(Text("Delete Pet"),
                                             action: {
                                                 vm.deletePet()
                                                 presentationMode.wrappedValue.dismiss()
                                                 vm.completionHandler?(.success(.delete))
                                             }),
                                .cancel()
                            ])
            }
        }
        .fullScreenCover(isPresented: $vm.showImagePicker, onDismiss: nil) {
            ImagePicker(image: $vm.petDetails.image)
                .ignoresSafeArea()
        }
        .alert(isPresented: $vm.hasError, content: {
            if case .failed(let error) = vm.state {
                return Alert(
                    title: Text("Error"),
                    message: Text(error.localizedDescription)
                )
            } else {
                return Alert(
                    title: Text("Error"),
                    message: Text("Something went wrong")
                )
            }
        })
    }
}

struct EditAddPetScreen_Previews: PreviewProvider {
    static var previews: some View {
        EditAddPetScreen()
    }
}
