import SwiftUI

struct LogInScreen: View {
    
    @State var maxCircleHeight: CGFloat = 0
    @State var showSignUp = false
    @State var showForgot = false
    
    var body: some View {
        VStack{
            //since height will vary for different screens
            //so in order to get the height we use geo
            GeometryReader{proxy -> AnyView in
                
                let height = proxy.frame(in: .global).height
                
                DispatchQueue.main.async {
                    if maxCircleHeight == 0 {
                        maxCircleHeight = height
                    }
                }
                
                return AnyView(
                    ZStack{
                        
                        Circle()
                            .fill(Color("darkBrown"))
                            .offset(x: getRect().width / 2, y: -height / 1.3)
                        
                        Circle()
                            .fill(Color("darkBrown"))
                            .offset(x: -getRect().width / 2, y: -height / 1.5)
                        
                        Circle()
                            .fill(Color("lightBrown"))
                            .offset(y: -height / 1.3)
                            .rotationEffect(.init(degrees: -5))
                        
                    }
                )
            }
            .frame(maxHeight: getRect().width)
            
            ZStack{
                if showForgot {
                    ForgotPassword()
                        .transition(.move(edge: .trailing))
                }else {
                    if showSignUp {
                        SignUp()
                            .transition(.move(edge: .trailing))
                    } else {
                        SignIn()
                            .transition(.move(edge: .trailing))
                    }
                }
            }
            .padding(.top, -maxCircleHeight / 1.6)
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .overlay(
            VStack{
                HStack{
                    if showSignUp {
                        
                    }else{
                        Text(showForgot ? "Remember already?" : "Forgot Password?")
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            withAnimation{
                                showForgot.toggle()
                            }
                        }) {
                            Text(showForgot ? "sign in" : "reset")
                                .fontWeight(.bold)
                                .foregroundColor(Color("lightBrown"))
                        }
                    }
                }
                
                HStack{
                    if showForgot {
                        
                    }else{
                        Text(showSignUp ? "Already have an account?" : "Don't have an account?")
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            withAnimation{
                                showSignUp.toggle()
                            }
                        }) {
                            Text(showSignUp ? "sign in" : "sign up")
                                .fontWeight(.bold)
                                .foregroundColor(Color("lightBrown"))
                        }
                    }
                }
                .padding(.top, 2)
            }
            ,alignment: .bottom
        )
        .background(
            //Bottom Rings
            HStack{
                Circle()
                    .fill(Color("lightBrown"))
                    .frame(width: 70, height: 70)
                    .offset(x: -30, y: 0)
                
                Spacer(minLength: 0)
                
                Circle()
                    .fill(Color("darkBrown"))
                    .frame(width: 110, height: 110)
                    .offset(x: 40, y: 20)
                
            }
                .offset(y: getSafeArea().bottom + 30)
            ,alignment: .bottom
        )
    }
}

struct LogInScreen_Previews: PreviewProvider {
    static var previews: some View {
        LogInScreen()
    }
}


//extending view to get screen size..
extension View {
    
    func getRect()->CGRect {
        return UIScreen.main.bounds
    }
    
    //Getting Safe Area
    func getSafeArea() -> UIEdgeInsets{
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
