import SwiftUI

struct MasterScreen: View {
    
    @State private var selection: Tab = .pets

    enum Tab {
        case pets, chat, favorite, more
    }

    var body: some View {
        TabView(selection: $selection) {
            PetsScreen()
                .tabItem {
                    Label("Pets", systemImage: "pawprint")
                }
                .tag(Tab.pets)

            ChatScreen()
                .tabItem {
                    Label("Chat", systemImage: "text.bubble")
                }
                .tag(Tab.chat)
            
            FavoriteScreen()
                .tabItem {
                    Label("Favorite", systemImage: "heart")
                }
                .tag(Tab.favorite)
            
            MoreScreen()
                .tabItem {
                    Label("More", systemImage: "ellipsis")
                }
                .tag(Tab.more)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            MasterScreen()
        }
    }
}
