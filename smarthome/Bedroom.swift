import SwiftUI

struct Bedroom: View {
    @State private var isNightLightOn = false
    @State private var alarmTime = Date()
    @State private var lightBrightness = 50.0
    @State private var temperature = 22.0
    @State private var humidity = 45.0
    @State private var selectedMode = "Normal"
    @State private var isWindowOpen = false
    
    let modes = ["Normal", "Uyku", "Okuma", "Romantik", "Gece"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Üst Durum Kartı
                StatusCard3(
                    isNightLightOn: isNightLightOn,
                    temperature: temperature,
                    humidity: humidity
                )
                
                // Gece Lambası Kontrolü
                NightLightCard(
                    isNightLightOn: $isNightLightOn,
                    brightness: $lightBrightness
                )
                
                // Alarm Kartı
                AlarmCard(alarmTime: $alarmTime)
                
                // Mod Seçici
                ModeCard(selectedMode: $selectedMode, modes: modes)
                
                // Oda Kontrolleri
                RoomControlsCard(
                    temperature: $temperature,
                    humidity: $humidity,
                    isWindowOpen: $isWindowOpen
                )
                
                // Uyku İstatistikleri
                SleepStatsCard()
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Image(systemName: "bed.double.fill")
                        .font(.title2)
                        .foregroundColor(.purple)
                    Text("Yatak Odası")
                        .font(.headline)
                }
            }
        }
    }
}

struct StatusCard3: View {
    let isNightLightOn: Bool
    let temperature: Double
    let humidity: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(Date(), style: .time)
                    .font(.system(size: 40, weight: .bold))
                Text("İyi Geceler")
                    .font(.title3)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                HStack {
                    Image(systemName: "thermometer")
                    Text("\(Int(temperature))°C")
                }
                HStack {
                    Image(systemName: "humidity.fill")
                    Text("\(Int(humidity))%")
                }
            }
            .font(.headline)
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

struct NightLightCard: View {
    @Binding var isNightLightOn: Bool
    @Binding var brightness: Double
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "lamp.table.fill")
                    .font(.title2)
                    .foregroundColor(.purple)
                
                Text("Gece Lambası")
                    .font(.headline)
                
                Spacer()
                
                Toggle("", isOn: $isNightLightOn)
                    .toggleStyle(SwitchToggleStyle(tint: .purple))
            }
            
            if isNightLightOn {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Parlaklık: \(Int(brightness))%")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Slider(value: $brightness, in: 0...100)
                        .tint(.purple)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(radius: 5)
        )
        .padding(.horizontal)
        .animation(.spring(), value: isNightLightOn)
    }
}

struct AlarmCard: View {
    @Binding var alarmTime: Date
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "alarm.fill")
                    .font(.title2)
                    .foregroundColor(.purple)
                
                Text("Alarm")
                    .font(.headline)
                
                Spacer()
            }
            
            DatePicker("Alarm", selection: $alarmTime, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(WheelDatePickerStyle())
                .frame(maxHeight: 100)
            
            HStack {
                ForEach(["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"], id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .padding(8)
                        .background(Circle().fill(Color.purple.opacity(0.2)))
                }
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

struct ModeCard: View {
    @Binding var selectedMode: String
    let modes: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(modes, id: \.self) { mode in
                    Button(action: { selectedMode = mode }) {
                        VStack(spacing: 8) {
                            Image(systemName: modeIcon(for: mode))
                                .font(.title2)
                            Text(mode)
                                .font(.caption)
                        }
                        .foregroundColor(selectedMode == mode ? .white : .purple)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(selectedMode == mode ? Color.purple : Color.purple.opacity(0.2))
                        )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
    func modeIcon(for mode: String) -> String {
        switch mode {
        case "Normal": return "house.fill"
        case "Uyku": return "moon.fill"
        case "Okuma": return "book.fill"
        case "Romantik": return "heart.fill"
        case "Gece": return "stars.fill"
        default: return "house.fill"
        }
    }
}

struct RoomControlsCard: View {
    @Binding var temperature: Double
    @Binding var humidity: Double
    @Binding var isWindowOpen: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Oda Kontrolleri")
                .font(.headline)
            
            HStack(spacing: 30) {
                VStack {
                    Image(systemName: "thermometer")
                        .font(.title2)
                        .foregroundColor(.orange)
                    Text("\(Int(temperature))°C")
                        .font(.title3)
                    Slider(value: $temperature, in: 18...30)
                        .frame(width: 100)
                        .tint(.orange)
                }
                
                VStack {
                    Image(systemName: "humidity.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                    Text("\(Int(humidity))%")
                        .font(.title3)
                    Slider(value: $humidity, in: 30...70)
                        .frame(width: 100)
                        .tint(.blue)
                }
            }
            
            Toggle(isOn: $isWindowOpen) {
                Label("Pencere", systemImage: "window.ceiling")
            }
            .toggleStyle(SwitchToggleStyle(tint: .purple))
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

struct SleepStatsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Uyku İstatistikleri")
                .font(.headline)
            
            HStack(spacing: 30) {
                VStack {
                    Text("7s 30dk")
                        .font(.title2)
                        .foregroundColor(.purple)
                    Text("Uyku Süresi")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                VStack {
                    Text("92%")
                        .font(.title2)
                        .foregroundColor(.purple)
                    Text("Uyku Kalitesi")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
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
