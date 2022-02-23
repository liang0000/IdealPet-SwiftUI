import SwiftUI

struct PetsScreen: View {
    
    @EnvironmentObject var vm: AccountViewModelImpl
    
    var body: some View {
        VStack(spacing:5){
            Text("Name: \(vm.accountDetails.name)")
            Text("Phone Number: \(vm.accountDetails.phoneNum)")
        }
    }
}

struct PetScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            PetsScreen()
                .environmentObject(AccountViewModelImpl(service: AccountServiceImpl()))
        }
    }
}
