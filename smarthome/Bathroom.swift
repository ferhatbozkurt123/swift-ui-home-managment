import SwiftUI

struct Bathroom: View {
    @State private var isFanOn = false
    @State private var waterTemperature = 38.0
    @State private var isShowerOn = false
    @State private var waterPressure = 70.0
    @State private var humidity = 65.0
    @State private var roomTemperature = 24.0
    @State private var selectedMode = "Normal"
    @State private var showingTimer = false
    @State private var timerMinutes = 15
    
    let modes = ["Normal", "Ekonomik", "Güçlü", "Spa"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Durum Kartı
                StatusCard4(
                    isShowerOn: isShowerOn,
                    waterTemperature: waterTemperature,
                    humidity: humidity,
                    roomTemperature: roomTemperature
                )
                
                // Duş Kontrol Kartı
                ShowerControlCard(
                    isShowerOn: $isShowerOn,
                    waterTemperature: $waterTemperature,
                    waterPressure: $waterPressure
                )
                
                // Havalandırma Kartı
                VentilationCard(
                    isFanOn: $isFanOn,
                    humidity: humidity
                )
                
                // Mod Seçici
                BathModeCard(
                    selectedMode: $selectedMode,
                    modes: modes
                )
                
                // Zamanlayıcı Kartı
                TimerCard(
                    showingTimer: $showingTimer,
                    timerMinutes: $timerMinutes
                )
                
                // Su Tüketimi Kartı
                WaterUsageCard()
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Image(systemName: "shower.fill")
                        .font(.title2)
                        .foregroundColor(.teal)
                    Text("Banyo")
                        .font(.headline)
                }
            }
        }
    }
}

struct StatusCard4: View {
    let isShowerOn: Bool
    let waterTemperature: Double
    let humidity: Double
    let roomTemperature: Double
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Circle()
                        .fill(isShowerOn ? Color.green : Color.red)
                        .frame(width: 10, height: 10)
                    Text(isShowerOn ? "Aktif" : "Beklemede")
                        .font(.headline)
                }
                Text("\(Int(waterTemperature))°C")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.teal)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 8) {
                HStack {
                    Image(systemName: "thermometer")
                    Text("\(Int(roomTemperature))°C")
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

struct ShowerControlCard: View {
    @Binding var isShowerOn: Bool
    @Binding var waterTemperature: Double
    @Binding var waterPressure: Double
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "shower.fill")
                    .font(.title2)
                    .foregroundColor(.teal)
                
                Text("Duş Kontrolü")
                    .font(.headline)
                
                Spacer()
                
                Toggle("", isOn: $isShowerOn)
                    .toggleStyle(SwitchToggleStyle(tint: .teal))
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Su Sıcaklığı: \(Int(waterTemperature))°C")
                    .font(.subheadline)
                
                HStack {
                    Image(systemName: "thermometer.low")
                        .foregroundColor(.blue)
                    Slider(value: $waterTemperature, in: 30...50)
                        .tint(.teal)
                    Image(systemName: "thermometer.high")
                        .foregroundColor(.red)
                }
                
                Text("Su Basıncı: \(Int(waterPressure))%")
                    .font(.subheadline)
                
                HStack {
                    Image(systemName: "drop")
                    Slider(value: $waterPressure, in: 0...100)
                        .tint(.teal)
                    Image(systemName: "drop.fill")
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

struct VentilationCard: View {
    @Binding var isFanOn: Bool
    let humidity: Double
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "fan.fill")
                    .font(.title2)
                    .foregroundColor(.teal)
                    .rotationEffect(.degrees(isFanOn ? 360 : 0))
                    .animation(isFanOn ? Animation.linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isFanOn)
                
                Text("Havalandırma")
                    .font(.headline)
                
                Spacer()
                
                Toggle("", isOn: $isFanOn)
                    .toggleStyle(SwitchToggleStyle(tint: .teal))
            }
            
            if humidity > 70 {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.yellow)
                    Text("Yüksek Nem Seviyesi")
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

struct BathModeCard: View {
    @Binding var selectedMode: String
    let modes: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Banyo Modu")
                .font(.headline)
            
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
                            .foregroundColor(selectedMode == mode ? .white : .teal)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(selectedMode == mode ? Color.teal : Color.teal.opacity(0.2))
                            )
                        }
                    }
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
    
    func modeIcon(for mode: String) -> String {
        switch mode {
        case "Normal": return "drop.fill"
        case "Ekonomik": return "leaf.fill"
        case "Güçlü": return "bolt.fill"
        case "Spa": return "sparkles"
        default: return "drop.fill"
        }
    }
}

struct TimerCard: View {
    @Binding var showingTimer: Bool
    @Binding var timerMinutes: Int
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "timer")
                    .font(.title2)
                    .foregroundColor(.teal)
                
                Text("Zamanlayıcı")
                    .font(.headline)
                
                Spacer()
                
                Toggle("", isOn: $showingTimer)
                    .toggleStyle(SwitchToggleStyle(tint: .teal))
            }
            
            if showingTimer {
                Picker("Dakika", selection: $timerMinutes) {
                    ForEach([5, 10, 15, 20, 25, 30], id: \.self) { minute in
                        Text("\(minute) dk").tag(minute)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
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

struct WaterUsageCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Su Tüketimi")
                .font(.headline)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Günlük")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("120 L")
                        .font(.title2)
                        .foregroundColor(.teal)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Aylık")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("3.6 m³")
                        .font(.title2)
                        .foregroundColor(.teal)
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
