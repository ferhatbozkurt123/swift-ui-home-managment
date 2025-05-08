import SwiftUI

struct LivingRoom: View {
    @State private var isLightOn = true
    @State private var temperature = 22.0
    @State private var lightBrightness = 80.0
    @State private var selectedScene = "Normal"
    @State private var curtainPosition = 50.0
    @State private var musicVolume = 30.0
    @State private var isAirPurifierOn = true
    @State private var selectedColor = Color.white
    @State private var showingColorPicker = false
    @State private var isMotionSensorOn = true
    
    let scenes = ["Normal", "Film", "Okuma", "Parti", "Romantik", "Uyku"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Hava Durumu ve Saat Kartı
                WeatherTimeCard1()
                
                // Ana Kontrol Kartı
                MainStatusCard(
                    temperature: temperature,
                    isLightOn: isLightOn,
                    airQuality: "İyi",
                    humidity: "45%"
                )
                
                // Hızlı Kontroller
                QuickControlsView1(
                    isLightOn: $isLightOn,
                    isAirPurifierOn: $isAirPurifierOn,
                    isMotionSensorOn: $isMotionSensorOn
                )
                
                // Aydınlatma Kontrolleri
                LightingControlCard1(
                    isLightOn: $isLightOn,
                    brightness: $lightBrightness,
                    selectedColor: $selectedColor,
                    showingColorPicker: $showingColorPicker
                )
                
                // İklim Kontrolleri
                ClimateControlCard1(
                    temperature: $temperature,
                    isAirPurifierOn: $isAirPurifierOn
                )
                
                // Perde Kontrolleri
                CurtainControlCard1(position: $curtainPosition)
                
                // Müzik Kontrolleri
                MusicControlCard1(volume: $musicVolume)
                
                // Sahne Seçimi
                ScenesCard(
                    scenes: scenes,
                    selectedScene: $selectedScene
                )
                
                // Enerji Kullanımı Kartı
                EnergyUsageCard()
            }
            .padding(.vertical)
        }
        .navigationTitle("Oturma Odası")
        .sheet(isPresented: $showingColorPicker) {
            ColorPickerView(selectedColor: $selectedColor)
        }
    }
}

// Alt Bileşenler

struct WeatherTimeCard1: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("27 Aralık 2024")
                    .font(.subheadline)
                Text("20:31")
                    .font(.title)
                    .bold()
            }
            Spacer()
            VStack(alignment: .trailing) {
                HStack {
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.yellow)
                    Text("24°C")
                        .font(.title2)
                }
                Text("Açık")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(radius: 5)
        )
        .padding(.horizontal)
    }
}

struct MainStatusCard: View {
    let temperature: Double
    let isLightOn: Bool
    let airQuality: String
    let humidity: String
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 20) {
            StatusItem1(
                icon: "thermometer",
                value: "\(Int(temperature))°C",
                title: "Sıcaklık",
                color: .orange
            )
            StatusItem1(
                icon: isLightOn ? "lightbulb.fill" : "lightbulb",
                value: isLightOn ? "Açık" : "Kapalı",
                title: "Aydınlatma",
                color: isLightOn ? .yellow : .gray
            )
            StatusItem1(
                icon: "aqi.medium",
                value: airQuality,
                title: "Hava Kalitesi",
                color: .green
            )
            StatusItem1(
                icon: "humidity",
                value: humidity,
                title: "Nem",
                color: .blue
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(radius: 5)
        )
        .padding(.horizontal)
    }
}

struct QuickControlsView1: View {
    @Binding var isLightOn: Bool
    @Binding var isAirPurifierOn: Bool
    @Binding var isMotionSensorOn: Bool
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                QuickControlButton6(
                    icon: "lightbulb.fill",
                    title: "Ana Işık",
                    isOn: $isLightOn,
                    color: .yellow
                )
                QuickControlButton6(
                    icon: "air.purifier.fill",
                    title: "Hava Temizleyici",
                    isOn: $isAirPurifierOn,
                    color: .blue
                )
                QuickControlButton6(
                    icon: "sensor.fill",
                    title: "Hareket Sensörü",
                    isOn: $isMotionSensorOn,
                    color: .purple
                )
            }
            .padding(.horizontal)
        }
    }
}

// Diğer kartlar için benzer yapılar...

struct QuickControlButton6: View {
    let icon: String
    let title: String
    @Binding var isOn: Bool
    let color: Color
    
    var body: some View {
        Button(action: { isOn.toggle() }) {
            VStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(isOn ? color : .gray)
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(isOn ? color.opacity(0.2) : Color(.systemGray6))
            )
        }
    }
}

// Renk Seçici Görünümü
struct ColorPickerView: View {
    @Binding var selectedColor: Color
    @Environment(\.presentationMode) var presentationMode
    
    let colors: [Color] = [.white, .red, .orange, .yellow, .green, .blue, .purple]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                    ForEach(colors, id: \.self) { color in
                        ColorButton(color: color, selectedColor: $selectedColor)
                    }
                }
                .padding()
            }
            .navigationTitle("Renk Seç")
            .navigationBarItems(trailing: Button("Tamam") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ColorButton: View {
    let color: Color
    @Binding var selectedColor: Color
    
    var body: some View {
        Button(action: { selectedColor = color }) {
            Circle()
                .fill(color)
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(selectedColor == color ? Color.blue : Color.clear, lineWidth: 3)
                )
                .shadow(radius: 3)
        }
    }
}

struct LightingControlCard1: View {
    @Binding var isLightOn: Bool
    @Binding var brightness: Double
    @Binding var selectedColor: Color
    @Binding var showingColorPicker: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Aydınlatma")
                .font(.headline)
            
            Toggle("Ana Işık", isOn: $isLightOn)
            
            VStack(alignment: .leading) {
                Text("Parlaklık: \(Int(brightness))%")
                Slider(value: $brightness, in: 0...100)
            }
            
            Button(action: { showingColorPicker.toggle() }) {
                HStack {
                    Text("Renk Seç")
                    Circle()
                        .fill(selectedColor)
                        .frame(width: 24, height: 24)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemBackground)))
        .shadow(radius: 5)
    }
}

struct ClimateControlCard1: View {
    @Binding var temperature: Double
    @Binding var isAirPurifierOn: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("İklim Kontrolü")
                .font(.headline)
            
            VStack(alignment: .leading) {
                Text("Sıcaklık: \(Int(temperature))°C")
                Slider(value: $temperature, in: 16...30)
            }
            
            Toggle("Hava Temizleyici", isOn: $isAirPurifierOn)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemBackground)))
        .shadow(radius: 5)
    }
}

struct CurtainControlCard1: View {
    @Binding var position: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Perde Kontrolü")
                .font(.headline)
            
            VStack(alignment: .leading) {
                Text("Perde Konumu: \(Int(position))%")
                Slider(value: $position, in: 0...100)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemBackground)))
        .shadow(radius: 5)
    }
}

struct MusicControlCard1: View {
    @Binding var volume: Double
    @State private var isPlaying = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Müzik")
                .font(.headline)
            
            Button(action: { isPlaying.toggle() }) {
                Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading) {
                Text("Ses: \(Int(volume))%")
                Slider(value: $volume, in: 0...100)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemBackground)))
        .shadow(radius: 5)
    }
}

struct ScenesCard: View {
    let scenes: [String]
    @Binding var selectedScene: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Sahneler")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(scenes, id: \.self) { scene in
                        Button(action: { selectedScene = scene }) {
                            Text(scene)
                                .padding()
                                .background(selectedScene == scene ? Color.blue : Color(.systemGray5))
                                .foregroundColor(selectedScene == scene ? .white : .primary)
                                .cornerRadius(10)
                        }
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemBackground)))
        .shadow(radius: 5)
    }
}

struct EnergyUsageCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Enerji Kullanımı")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Günlük Kullanım")
                    Text("2.4 kWh")
                        .font(.title2)
                        .foregroundColor(.green)
                }
                Spacer()
                Image(systemName: "leaf.fill")
                    .foregroundColor(.green)
                    .font(.title)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color(.systemBackground)))
        .shadow(radius: 5)
    }
}

// StatusItem yapısını güncelleyelim
struct StatusItem1: View {
    let icon: String
    let value: String
    let title: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            Text(value)
                .font(.headline)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(10)
    }
}
