import SwiftUI

// MARK: - Ana Görünüm
struct ThermostatView: View {
    // MARK: - State Değişkenleri
    @State private var temperature = 22.0
    @State private var selectedDevice = "Salon Kliması"
    @State private var insideHumidity = 49
    @State private var outsideTemperature = -10
    @State private var isHeating = true
    @State private var isPowerOn = true
    @State private var selectedMode = ClimateMode.auto
    @State private var fanSpeed = 2
    @State private var showSchedule = false
    @State private var isEcoMode = false
    
    let devices = ["Salon Kliması", "Yatak Odası Kliması", "Çalışma Odası Kliması"]
    
    // MARK: - Ana Görünüm
    var body: some View {
        ZStack {
            backgroundGradient
            
            ScrollView {
                VStack(spacing: 25) {
                    deviceSelector
                    temperatureRing
                    modeSelector
                    fanSpeedControl
                    statisticsPanel
                    bottomNavigationBar
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                powerButton
            }
        }
    }
    
    // MARK: - Bileşenler
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(red: 0.1, green: 0.2, blue: 0.3),
                Color(red: 0.2, green: 0.3, blue: 0.4)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .opacity(0.1)
        .ignoresSafeArea()
    }
    
    private var deviceSelector: some View {
        VStack(spacing: 8) {
            Menu {
                ForEach(devices, id: \.self) { device in
                    Button(device) {
                        selectedDevice = device
                    }
                }
            } label: {
                HStack {
                    Text(selectedDevice)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Image(systemName: "chevron.down")
                }
            }
            
            LocationBadge()
        }
    }
    
    private var temperatureRing: some View {
        ZStack {
            Circle()
                .stroke(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 30
                )
                .frame(width: 280, height: 280)
            
            VStack(spacing: 15) {
                Text("\(Int(temperature))°")
                    .font(.system(size: 72, weight: .bold))
                
                HStack(spacing: 30) {
                    EnvironmentStatus(
                        icon: "humidity.fill",
                        value: "\(insideHumidity)%",
                        label: "Nem"
                    )
                    
                    EnvironmentStatus(
                        icon: "thermometer",
                        value: "\(outsideTemperature)°",
                        label: "Dış"
                    )
                }
            }
        }
        .gesture(
            DragGesture()
                .onChanged(handleTemperatureChange)
        )
    }
    
    private var modeSelector: some View {
        HStack(spacing: 15) {
            ForEach(ClimateMode.allCases, id: \.self) { mode in
                ClimateModeButton(
                    mode: mode,
                    isSelected: mode == selectedMode
                )
                .onTapGesture {
                    selectedMode = mode
                }
            }
        }
    }
    
    private var fanSpeedControl: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Fan Hızı")
                .font(.headline)
            
            HStack(spacing: 20) {
                ForEach(1...3, id: \.self) { speed in
                    FanSpeedButton(
                        level: speed,
                        isSelected: speed == fanSpeed
                    )
                    .onTapGesture {
                        fanSpeed = speed
                    }
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.1)))
    }
    
    private var statisticsPanel: some View {
        VStack(spacing: 15) {
            HStack {
                Text("İstatistikler")
                    .font(.headline)
                Spacer()
            }
            
            HStack(spacing: 20) {
                StatisticCard(
                    title: "Enerji",
                    value: "2.4 kWh",
                    icon: "bolt.fill"
                )
                
                StatisticCard(
                    title: "Çalışma",
                    value: "6.5 saat",
                    icon: "clock.fill"
                )
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.1)))
    }
    
    private var bottomNavigationBar: some View {
        HStack(spacing: 40) {
            BottomNavButton(icon: "house.fill", title: "Ana Sayfa", isActive: true)
            BottomNavButton(icon: "calendar", title: "Program", isActive: false)
            BottomNavButton(icon: "chart.bar.fill", title: "İstatistik", isActive: false)
            BottomNavButton(icon: "gearshape.fill", title: "Ayarlar", isActive: false)
        }
    }
    
    private var powerButton: some View {
        Button {
            isPowerOn.toggle()
        } label: {
            Image(systemName: "power.circle.fill")
                .foregroundColor(isPowerOn ? .green : .red)
                .font(.title2)
        }
    }
    
    // MARK: - Yardımcı Fonksiyonlar
    private func handleTemperatureChange(_ value: DragGesture.Value) {
        let vector = CGVector(
            dx: value.location.x - 140,
            dy: value.location.y - 140
        )
        let angle = atan2(vector.dy, vector.dx) + .pi
        let newTemp = Double(angle) * 30 / .pi
        temperature = min(max(newTemp, 16), 30)
    }
}

// MARK: - Yardımcı Görünümler
struct LocationBadge: View {
    var body: some View {
        HStack {
            Image(systemName: "location.fill")
                .foregroundColor(.blue)
            Text("Ev")
                .foregroundColor(.gray)
        }
    }
}

struct EnvironmentStatus: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(value)
                .font(.system(size: 14, weight: .medium))
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
    }
}

struct ClimateModeButton: View {
    let mode: ClimateMode
    let isSelected: Bool
    
    var body: some View {
        VStack {
            Image(systemName: mode.icon)
            Text(mode.rawValue)
                .font(.caption)
        }
        .padding()
        .frame(width: 80, height: 80)
        .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
        .cornerRadius(15)
        .foregroundColor(isSelected ? .white : .gray)
    }
}

struct FanSpeedButton: View {
    let level: Int
    let isSelected: Bool
    
    var body: some View {
        VStack {
            ForEach(0..<level, id: \.self) { _ in
                Rectangle()
                    .frame(width: 20, height: 3)
            }
        }
        .padding()
        .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct StatisticCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .foregroundColor(.gray)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white.opacity(0.1))
        .cornerRadius(15)
    }
}

struct BottomNavButton: View {
    let icon: String
    let title: String
    let isActive: Bool
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
            Text(title)
                .font(.caption)
        }
        .foregroundColor(isActive ? .blue : .gray)
    }
}

// MARK: - Enum
enum ClimateMode: String, CaseIterable {
    case auto = "Otomatik"
    case cool = "Soğutma"
    case heat = "Isıtma"
    case fan = "Fan"
    
    var icon: String {
        switch self {
        case .auto: return "a.circle.fill"
        case .cool: return "snowflake"
        case .heat: return "flame.fill"
        case .fan: return "fan.fill"
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        ThermostatView()
    }
}
