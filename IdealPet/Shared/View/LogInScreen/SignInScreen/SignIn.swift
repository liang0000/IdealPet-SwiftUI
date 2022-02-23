import SwiftUI

struct SignIn: View {
    
    @StateObject private var vm = SignInViewModelImpl(service: SignInServiceImpl())
    
    var body: some View {
        VStack{
            Text("Sign In")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("darkBrown"))
                .kerning(1.9)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Email and Password...
            VStack(alignment: .leading, spacing: 8){
                Text("Email Address")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                TextField("enter email address", text: $vm.credentials.email)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color("darkBrown"))
                    .keyboardType(.emailAddress)
                
                Divider()
            }
            .padding(.top, 10)
            
            VStack(alignment: .leading, spacing: 8){
                Text("Password")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                SecureField("enter password", text: $vm.credentials.password)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color("darkBrown"))
                
                Divider()
            }
            .padding(.top, 20)
            
            // Sign In Button..
            Button(action: {
                vm.signIn()
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
                    message: Text("Something went wrong")
                )
            }
        })
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn()
    }
}
