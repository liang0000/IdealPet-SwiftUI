import SwiftUI

struct ManagePetsScreen: View {
    
    @State var showAddPet = false
    @StateObject var vm = PetsViewModel()
    
    var body: some View {
        List {
            ForEach(vm.pets) { pet in
                NavigationLink {
                    ManagePetsDetailScreen(pet: pet)
                } label: {
                    PetRow(pet: pet)
                }
            }
            .onDelete() { indexSet in
                vm.deletePets(atOffsets: indexSet)
            }
        }
        .navigationTitle("Manage Pets")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: { showAddPet.toggle() }) { Image(systemName: "plus") })
        .sheet(isPresented: $showAddPet) {
            EditAddPetScreen()
        }
        .onAppear() {
            vm.subscribe()
        }
    }
}

struct ManagePetsScreen_Previews: PreviewProvider {
    static var previews: some View {
        ManagePetsScreen()
    }
}
