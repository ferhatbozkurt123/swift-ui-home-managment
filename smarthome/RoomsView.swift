
import SwiftUI

struct RoomsView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Oturma Odası
            LivingRoom()
                .tabItem {
                    VStack {
                        Image(systemName: "sofa.fill")
                            .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                        Text("Oturma Odası")
                    }
                }
                .tag(0)
            
            // Mutfak
            Kitchen()
                .tabItem {
                    VStack {
                        Image(systemName: "cooktop.fill")
                            .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                        Text("Mutfak")
                    }
                }
                .tag(1)
            
            // Yatak Odası
            Bedroom()
                .tabItem {
                    VStack {
                        Image(systemName: "bed.double.fill")
                            .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                        Text("Yatak Odası")
                    }
                }
                .tag(2)
            
            // Banyo
            Bathroom()
                .tabItem {
                    VStack {
                        Image(systemName: "shower.fill")
                            .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                        Text("Banyo")
                    }
                }
                .tag(3)
            
            // Havuz
            Pool()
                .tabItem {
                    VStack {
                        Image(systemName: "drop.fill")
                            .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)
                        Text("Havuz")
                    }
                }
                .tag(4)
            
            // Bahçe
            Garden()
                .tabItem {
                    VStack {
                        Image(systemName: "leaf.fill")
                            .environment(\.symbolVariants, selectedTab == 5 ? .fill : .none)
                        Text("Bahçe")
                    }
                }
                .tag(5)
            
            // Diğer
            OtherRoomsView()
                .tabItem {
                    VStack {
                        Image(systemName: "ellipsis.circle.fill")
                            .environment(\.symbolVariants, selectedTab == 6 ? .fill : .none)
                        Text("Diğer")
                    }
                }
                .tag(6)
        }
        .accentColor(.blue) // Tab bar rengi
        .onAppear {
            // Tab bar görünümünü özelleştirme
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            
            // Normal durum
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.gray
            ]
            
            // Seçili durum
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemBlue
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.systemBlue
            ]
            
            // Gölge efekti
            appearance.shadowColor = UIColor.black.withAlphaComponent(0.2)
            
            UITabBar.appearance().standardAppearance = appearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
        .tint(.blue) // iOS 15+ için seçili tab rengi
    }
}

// Örnek bir oda view'ı için geliştirme
struct RoomViewTemplate: View {
    let roomName: String
    let iconName: String
    let backgroundColor: Color
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Üst banner
                    RoomHeaderBanner(roomName: roomName, iconName: iconName, backgroundColor: backgroundColor)
                    
                    // Hızlı kontroller
                    QuickControlsSection()
                    
                    // Cihazlar listesi
                    DevicesSection()
                    
                    // İstatistikler
                    StatisticsSection()
                }
                .padding()
            }
            .navigationTitle(roomName)
            .navigationBarTitleDisplayMode(.large)
            .background(Color(.systemGroupedBackground))
        }
    }
}

// Yardımcı view'lar
struct RoomHeaderBanner: View {
    let roomName: String
    let iconName: String
    let backgroundColor: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: iconName)
                .font(.system(size: 40))
                .foregroundColor(.white)
                .frame(width: 80, height: 80)
                .background(backgroundColor)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(roomName)
                    .font(.title2)
                    .bold()
                Text("23°C | Nem: %45")
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct QuickControlsSection: View {
    @State private var isLightOn = false
    @State private var temperature = 23.0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Hızlı Kontroller")
                .font(.headline)
            
            HStack(spacing: 20) {
                QuickControlButton(
                    icon: isLightOn ? "lightbulb.fill" : "lightbulb",
                    title: "Işıklar",
                    color: isLightOn ? .yellow : .gray,
                    action: { isLightOn.toggle() }
                )
                
                QuickControlButton(
                    icon: "thermometer",
                    title: "Sıcaklık",
                    color: .orange,
                    action: {}
                )
                
                QuickControlButton(
                    icon: "fanblades",
                    title: "Fan",
                    color: .blue,
                    action: {}
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct QuickControlButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 25))
                    .foregroundColor(color)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
    }
}

struct DevicesSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Cihazlar")
                .font(.headline)
            
            ForEach(["Akıllı Lamba", "Klima", "TV", "Priz"], id: \.self) { device in
                DeviceRow(deviceName: device)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct DeviceRow: View {
    let deviceName: String
    @State private var isOn = false
    
    var body: some View {
        HStack {
            Image(systemName: isOn ? "power.circle.fill" : "power.circle")
                .foregroundColor(isOn ? .green : .gray)
            Text(deviceName)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct StatisticsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("İstatistikler")
                .font(.headline)
            
            HStack {
                StatCard(title: "Enerji", value: "2.4 kWh", icon: "bolt.fill", color: .yellow)
                StatCard(title: "Su", value: "120 L", icon: "drop.fill", color: .blue)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
            Text(title)
                .font(.caption)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
