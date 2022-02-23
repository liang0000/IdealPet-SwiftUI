import SwiftUI

struct ForgotPassword: View {
    
    @StateObject private var vm = ForgotPasswordViewModelImpl(service: ForgotPasswordServiceImpl())
    
    var body: some View {
        VStack{
            Text("Forgot Password")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("darkBrown"))
                .kerning(1.9)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8){
                Text("Email Address")
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                
                TextField("enter email address", text: $vm.email)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(Color("darkBrown"))
                    .padding(.top, 5)
                
                Divider()
            }
            .padding(.top, 10)
            
            Button(action: {
                vm.sendPasswordReset()
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
                    title: Text("Successfully Sent"),
                    message: Text("Please check your email for reset link.")
                )
            }
        })
    }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPassword()
    }
}
