import SwiftUI
import Combine
import SDWebImageSwiftUI

struct ManageAccountScreen: View {
    
    @StateObject var vm = AccountViewModelImpl(service: AccountServiceImpl())
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            Form {
//                Section(header: Text("User Image")){
//                    HStack{
//                        Button(action: {
//                            vm.showImagePicker.toggle()
//                        }) {
//                            if let image = vm.petDetails.image {
//                                Image(uiImage: image)
//                                    .resizable()
//                                    .frame(height: 100)
//                                    .clipShape(Circle())
//                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
//                                    .shadow(radius: 7)
//                            }
//                            else if let image = vm.petDetails.imageURL {
//                                AnimatedImage(url: URL(string: image))
//                                    .resizable()
//                                    .frame(height: 100)
//                                    .clipShape(Circle())
//                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
//                                    .shadow(radius: 7)
//                            }
//                            else {
//                                Image(systemName: "person.fill")
//                                    .font(.system(size: 54))
//                                    .padding()
//                                    .foregroundColor(Color(.label))
//                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
//                                    .shadow(radius: 7)
//                            }
//                        }
//                    }
//                    .padding()
//                    .frame(width: 310)
//                }

                Section(header: Text("User Profile")) {
                    HStack{
                        Text("Name")
                            .frame(width: 80, alignment: .leading)
                        TextField("please enter name", text: $vm.accountDetails.name)
                    }
                    
                    HStack{
                        Text("Email")
                            .frame(width: 80, alignment: .leading)
                        TextField("please enter email", text: $vm.accountDetails.email)
                    }
                    
                    HStack{
                        Text("Phone Number")
                            .frame(width: 80, alignment: .leading)
                        TextField("please enter phone number", text: $vm.accountDetails.phoneNum)
                            .keyboardType(.numberPad)
                            .onReceive(Just(vm.accountDetails.phoneNum)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    vm.accountDetails.phoneNum = filtered
                                }
                            }
                    }
                    
                    HStack{
                        Text("Password")
                            .frame(width: 80, alignment: .leading)
                        SecureField("please enter password", text: $vm.accountDetails.password)
                        
                    }
                }
            }
            .navigationTitle(vm.accountDetails.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                },
                trailing: Button(action: {
                    vm.updateAccount()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                }
                    .disabled(vm.accountDetails.name.isEmpty || vm.accountDetails.phoneNum.isEmpty ||
                              vm.accountDetails.email.isEmpty || vm.accountDetails.password.isEmpty)
//                              || vm.accountDetails.image == nil)
            )
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
                    message: Text("Something went wrong.")
                )
            }
        })
//        .fullScreenCover(isPresented: $vm.showImagePicker, onDismiss: nil) {
//            ImagePicker(image: $vm.accountDetails.image)
//                .ignoresSafeArea()
//        }
    }
}

struct ManageAccountScreen_Previews: PreviewProvider {
    static var previews: some View {
        ManageAccountScreen()
    }
}
