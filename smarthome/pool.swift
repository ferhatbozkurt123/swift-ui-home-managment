import SwiftUI

struct Pool: View {
    // MARK: - Properties
    @State private var isPoolCleanerOn = false
    @State private var waterTemperature = 28.0
    @State private var selectedMode = "Normal"
    @State private var filterStatus = 85.0
    @State private var chlorineLevel = 72.0
    @State private var phLevel = 7.2
    
    let modes = ["Normal", "Eco", "Boost", "Night"]
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                waterStatusCard
                poolCleanerControls
                waterQualityStats
            }
            .padding(.vertical)
        }
        .navigationTitle("Havuz Kontrolü")
        .background(Color(.systemGroupedBackground))
    }
    
    // MARK: - Water Status Card
    private var waterStatusCard: some View {
        VStack(spacing: 20) {
            // Temperature Circle
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                .blue.opacity(0.3),
                                .blue.opacity(0.1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 160, height: 160)
                
                VStack(spacing: 8) {
                    Image(systemName: "drop.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                        .symbolEffect(.bounce, options: .repeating)
                    
                    Text("\(Int(waterTemperature))°C")
                        .font(.system(size: 32, weight: .bold, design: .rounded))
                    
                    Text("Su Sıcaklığı")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Temperature Control
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: "thermometer")
                        .foregroundColor(.blue)
                    Text("Sıcaklık Kontrolü")
                        .font(.headline)
                }
                
                HStack {
                    Image(systemName: "snowflake")
                        .foregroundColor(.blue)
                        .font(.system(size: 20))
                    
                    Slider(value: $waterTemperature, in: 20...35, step: 0.5)
                        .tint(.blue)
                    
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.orange)
                        .font(.system(size: 20))
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
    
    // MARK: - Pool Cleaner Controls
    private var poolCleanerControls: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Havuz Temizleyici")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "bubbles.and.sparkles.fill")
                        .foregroundColor(.blue)
                        .symbolEffect(.bounce, options: .repeating)
                    
                    Text("Otomatik Temizleyici")
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Toggle("", isOn: $isPoolCleanerOn)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(modes, id: \.self) { mode in
                            ModaButton(
                                title: mode,
                                icon: modeIcon(mode),
                                isSelected: selectedMode == mode,
                                action: {
                                    withAnimation {
                                        selectedMode = mode
                                    }
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 5)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Water Quality Stats
    private var waterQualityStats: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Su Kalitesi")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 15) {
                WaterQualityRow(
                    title: "Filtre Durumu",
                    value: filterStatus,
                    unit: "%",
                    icon: "gauge.medium",
                    color: filterStatusColor
                )
                
                WaterQualityRow(
                    title: "Klor Seviyesi",
                    value: chlorineLevel,
                    unit: "%",
                    icon: "drop.fill",
                    color: chlorineLevelColor
                )
                
                WaterQualityRow(
                    title: "pH Seviyesi",
                    value: phLevel,
                    unit: "",
                    icon: "waveform.path.ecg",
                    color: phLevelColor
                )
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helper Functions
    private func modeIcon(_ mode: String) -> String {
        switch mode {
        case "Normal": return "gauge.medium"
        case "Eco": return "leaf.fill"
        case "Boost": return "bolt.fill"
        case "Night": return "moon.stars.fill"
        default: return "circle.fill"
        }
    }
    
    // MARK: - Computed Properties
    private var filterStatusColor: Color {
        switch filterStatus {
        case 0...30: return .red
        case 31...70: return .orange
        default: return .blue
        }
    }
    
    private var chlorineLevelColor: Color {
        switch chlorineLevel {
        case 0...40: return .red
        case 41...60: return .orange
        default: return .blue
        }
    }
    
    private var phLevelColor: Color {
        switch phLevel {
        case 0...6.5: return .red
        case 6.6...7.8: return .blue
        default: return .orange
        }
    }
}

// MARK: - Supporting Views
struct WaterQualityRow: View {
    let title: String
    let value: Double
    let unit: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .frame(width: 30)
                .font(.system(size: 18))
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text("\(value, specifier: "%.1f")\(unit)")
                .font(.headline)
                .foregroundColor(color)
        }
    }
}

struct ModaButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .symbolEffect(.bounce, options: .repeating)
                
                Text(title)
                    .font(.caption)
                    .bold()
            }
            .padding()
            .frame(minWidth: 80)
            .background(isSelected ? Color.blue : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(12)
            .animation(.spring(), value: isSelected)
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        Pool()
    }
}
