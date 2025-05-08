import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Home()
                .tabItem {
                    Label("Evim", systemImage: "house.fill")
                }
                .tag(0)
            
            RoomsView()
                .tabItem {
                    Label("Odalar", systemImage: "bed.double.fill")
                }
                .tag(1)
            
            energy()
                           .tabItem {
                               Label("Enerji", systemImage: "bolt.fill")
                           }
                           .tag(2)
            
            Settings()
                .tabItem {
                    Label("Ayarlar", systemImage: "gearshape.fill")
                }
                .tag(3)
        }
        .accentColor(.blue)
        .preferredColorScheme(.light) // You can change to .dark if needed
        .onAppear {
            // Customize tab bar appearance
            UITabBar.appearance().backgroundColor = .systemBackground
            UITabBar.appearance().unselectedItemTintColor = .gray
        }
    }
}

// Example of an improved HomeView

// Reusable Quick Action Button


// Placeholder views for other tabs



