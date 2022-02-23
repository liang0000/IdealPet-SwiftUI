import SwiftUI
import Combine

struct SignUp: View {
    
    @StateObject private var vm = SignUpViewModelImpl(service: SignUpServiceImpl())
    
    var body: some View {
        VStack{
            Text("Sign Up")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("darkBrown"))
                .kerning(1.9)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Name, Phone Number, Email and Password...
            VStack(alignment: .leading, spacing: 8){
                Text("Name")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                TextField("enter name", text: $vm.userDetails.name)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color("darkBrown"))
                
                Divider()
            }
            .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 8){
                Text("Email Address")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                TextField("enter email address", text: $vm.userDetails.email)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color("darkBrown"))
                    .keyboardType(.emailAddress)
                
                Divider()
            }
            .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 8){
                Text("Phone Number")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                TextField("enter valid phone number", text: $vm.userDetails.phoneNum)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color("darkBrown"))
                    .keyboardType(.phonePad)
                    .onReceive(Just(vm.userDetails.phoneNum)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            vm.userDetails.phoneNum = filtered
                        }
                    }
                
                Divider()
            }
            .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 8){
                Text("Password")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                SecureField("enter password", text: $vm.userDetails.password)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color("darkBrown"))
                
                Divider()
            }
            .padding(.top, 20)
            
            // Sign Up Button
            Button(action: {
                vm.signUp()
            }) {
                Image(systemName: "arrow.right")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("darkBrown"))
                    .clipShape(Circle())
                    .shadow(color: Color("lightBrown").opacity(0.6), radius: 5, x: 0, y: 0)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 10)
        }
        .padding()
        .alert(isPresented: $vm.hasError, content: {
            if case .failed(let error) = vm.state {
                return Alert(
                    title: Text("Error"),
                    message: Text(error.localizedDescription)
                )
            } else {
                return Alert(
                    title: Text("Error"),
                    message: Text(vm.errorMessage)
                )
            }
        })
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
