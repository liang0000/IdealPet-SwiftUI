import SwiftUI

struct MoreScreen: View {
    
    @EnvironmentObject var vm: AccountViewModelImpl
    @State var showAccount = false
    @State var confirmLogOut = false
    
    var body: some View {
        
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: ManagePetsScreen()) {
                        Text("Manage Pets")
                    }
                }
                
                Section {
                    Button(action: {
                        showAccount.toggle()
                    }) {
                        Text("Manage Account")
                    }
                }
                
                Section {
                    Button("Log Out") { confirmLogOut.toggle() }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("More")
            .navigationBarTitleDisplayMode(.large)
            .actionSheet(isPresented: $confirmLogOut) {
                ActionSheet(title: Text("Confirm Log Out"),
                            buttons: [
                                .destructive(Text("Log Out"),
                                             action: { vm.logOut() }),
                                .cancel()
                            ])
            }
            .sheet(isPresented: $showAccount) {
                ManageAccountScreen(vm: AccountViewModelImpl(service: AccountServiceImpl()))
            }
        }
    }
}

struct MoreScreen_Previews: PreviewProvider {
    static var previews: some View {
        MoreScreen()
    }
}
