import SwiftUI

struct AllLight: View {
    @State private var rooms: [Room] = [
        Room(name: "Salon", icon: "sofa.fill", lights: [
            Light(name: "Ana Işık", isOn: false, brightness: 70, color: .yellow),
            Light(name: "Yan Işık", isOn: false, brightness: 50, color: .orange),
            Light(name: "Ambient", isOn: false, brightness: 30, color: .purple)
        ], theme: .blue),
        Room(name: "Mutfak", icon: "refrigerator.fill", lights: [
            Light(name: "Tavan", isOn: false, brightness: 100, color: .yellow),
            Light(name: "Tezgah", isOn: false, brightness: 80, color: .white)
        ], theme: .green),
        Room(name: "Yatak Odası", icon: "bed.double.fill", lights: [
            Light(name: "Ana Işık", isOn: false, brightness: 60, color: .yellow),
            Light(name: "Gece Lambası", isOn: false, brightness: 20, color: .orange)
        ], theme: .purple),
        Room(name: "Çalışma Odası", icon: "desk.fill", lights: [
            Light(name: "Ana Işık", isOn: false, brightness: 90, color: .yellow),
            Light(name: "Masa Lambası", isOn: false, brightness: 40, color: .blue)
        ], theme: .red)
    ]
    
    @State private var allLightsOn = false
    @State private var selectedMode = 0
    let modes = ["Tümü", "Aktif", "Kapalı"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Üst Durum Kartı
                HeaderView(allLightsOn: $allLightsOn, rooms: $rooms)
                
                // Mod Seçici
                Picker("Mode", selection: $selectedMode) {
                    ForEach(0..<modes.count) { index in
                        Text(modes[index])
                            .tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Hızlı Senaryolar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ScenarioButton(title: "Film Modu", icon: "film.fill", color: .purple)
                        ScenarioButton(title: "Gece Modu", icon: "moon.fill", color: .indigo)
                        ScenarioButton(title: "Okuma", icon: "book.fill", color: .blue)
                        ScenarioButton(title: "Parti", icon: "sparkles", color: .pink)
                    }
                    .padding(.horizontal)
                }
                
                // Odalar Listesi
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 20) {
                    ForEach($rooms) { $room in
                        RoomCard9(room: $room)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
        .navigationTitle("Aydınlatma")
        .background(Color(.systemGray6).ignoresSafeArea())
    }
}

struct HeaderView: View {
    @Binding var allLightsOn: Bool
    @Binding var rooms: [Room]
    
    var activeLightCount: Int {
        rooms.reduce(0) { $0 + $1.lights.filter(\.isOn).count }
    }
    
    var totalLightCount: Int {
        rooms.reduce(0) { $0 + $1.lights.count }
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Aktif Işıklar")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("\(activeLightCount)/\(totalLightCount)")
                            .font(.system(size: 34, weight: .bold))
                        Text("Işık Açık")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    PowerButton(isOn: $allLightsOn) {
                        toggleAllLights()
                    }
                }
                
                // Enerji Kullanımı Göstergesi
                EnergyUsageBar(percentage: Double(activeLightCount) / Double(totalLightCount))
            }
            .padding(20)
        }
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
    
    func toggleAllLights() {
        allLightsOn.toggle()
        for roomIndex in rooms.indices {
            for lightIndex in rooms[roomIndex].lights.indices {
                rooms[roomIndex].lights[lightIndex].isOn = allLightsOn
            }
        }
    }
}

struct RoomCard9: View {
    @Binding var room: Room
    
    var body: some View {
        VStack(spacing: 15) {
            // Oda Başlığı
            HStack {
                Image(systemName: room.icon)
                    .font(.title2)
                    .foregroundColor(room.theme)
                
                Text(room.name)
                    .font(.headline)
                
                Spacer()
                
                Text("\(room.activeLightCount)/\(room.lights.count)")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            // Işıklar Listesi
            ForEach($room.lights) { $light in
                LightControlRow(light: $light)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct LightControlRow: View {
    @Binding var light: Light
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Image(systemName: light.isOn ? "lightbulb.fill" : "lightbulb")
                    .foregroundColor(light.isOn ? light.color : .gray)
                
                Text(light.name)
                    .font(.subheadline)
                
                Spacer()
                
                Toggle("", isOn: $light.isOn)
                    .labelsHidden()
                    .tint(light.color)
            }
            
            // Parlaklık Kontrolü
            HStack {
                Image(systemName: "sun.min")
                    .foregroundColor(.gray)
                
                CustomSlider(value: $light.brightness, color: light.color)
                
                Image(systemName: "sun.max")
                    .foregroundColor(.gray)
            }
            .opacity(light.isOn ? 1 : 0.5)
        }
    }
}

struct PowerButton: View {
    @Binding var isOn: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(isOn ? Color.green : Color.red)
                    .frame(width: 50, height: 50)
                
                Image(systemName: "power")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
    }
}

struct ScenarioButton: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(.white)
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(color)
            )
        }
    }
}

struct EnergyUsageBar: View {
    let percentage: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Enerji Kullanımı")
                .font(.caption)
                .foregroundColor(.gray)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                    
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.blue, .green]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * percentage)
                }
            }
            .frame(height: 8)
            .cornerRadius(4)
        }
    }
}

struct CustomSlider: View {
    @Binding var value: Double
    let color: Color
    
    var body: some View {
        Slider(value: $value, in: 0...100)
            .tint(color)
    }
}

// Veri Modelleri
struct Room: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    var lights: [Light]
    let theme: Color
    
    var activeLightCount: Int {
        lights.filter { $0.isOn }.count
    }
}

struct Light: Identifiable {
    let id = UUID()
    let name: String
    var isOn: Bool
    var brightness: Double
    let color: Color
}

#Preview {
    NavigationView {
        AllLight()
    }
}
