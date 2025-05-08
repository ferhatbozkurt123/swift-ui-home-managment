import SwiftUI

struct Kitchen: View {
    @State private var isOvenOn = false
    @State private var isFridgeOn = true
    @State private var ovenTemperature = 180.0
    @State private var fridgeTemperature = 4.0
    @State private var selectedMode: ApplianceMode = .eco
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Ana Cihaz Kartları
                applianceCards
                
                // Hızlı Mod Seçimi
                modePicker
                
                // Hızlı Eylemler
                quickActions
                
                // Durum ve İzleme
                monitoringCard
            }
            .padding()
        }
        .navigationTitle("Akıllı Mutfak")
        .background(Color(.systemGroupedBackground))
    }
    
    private var applianceCards: some View {
        LazyVGrid(columns: [GridItem(.flexible())], spacing: 20) {
            modernApplianceCard(
                title: "Fırın",
                icon: "flame.fill",
                isOn: $isOvenOn,
                temperature: $ovenTemperature,
                color: .orange,
                range: 50...250,
                currentUsage: "1.2 kW/h",
                subtitle: "Ön Isıtma Modu"
            )
            
            modernApplianceCard(
                title: "Buzdolabı",
                icon: "snowflake",
                isOn: $isFridgeOn,
                temperature: $fridgeTemperature,
                color: .blue,
                range: 2...8,
                currentUsage: "0.8 kW/h",
                subtitle: "Enerji Tasarruf Modu"
            )
        }
    }
    
    private var modePicker: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Çalışma Modu")
                .font(.headline)
            
            HStack(spacing: 12) {
                ForEach(ApplianceMode.allCases, id: \.self) { mode in
                    modeButton(mode)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(radius: 5)
        )
    }
    
    private var quickActions: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Hızlı Eylemler")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    actionButton(title: "Ön Isıtma", icon: "thermometer", color: .orange)
                    actionButton(title: "Buz Çözme", icon: "snow", color: .blue)
                    actionButton(title: "Temizlik", icon: "sparkles", color: .purple)
                    actionButton(title: "Program", icon: "clock", color: .green)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(radius: 5)
        )
    }
    
    private var monitoringCard: some View {
        VStack(spacing: 20) {
            monitorRow(
                title: "Günlük Enerji",
                value: "3.2 kWh",
                icon: "bolt.circle.fill",
                color: .blue
            )
            
            Divider()
            
            monitorRow(
                title: "Son Bakım",
                value: "2 hafta önce",
                icon: "wrench.fill",
                color: .orange
            )
            
            Divider()
            
            monitorRow(
                title: "Filtre Durumu",
                value: "İyi",
                icon: "checkmark.seal.fill",
                color: .green
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(radius: 5)
        )
    }
    
    private func modernApplianceCard(
        title: String,
        icon: String,
        isOn: Binding<Bool>,
        temperature: Binding<Double>,
        color: Color,
        range: ClosedRange<Double>,
        currentUsage: String,
        subtitle: String
    ) -> some View {
        VStack(spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: icon)
                            .font(.title2)
                            .foregroundColor(color)
                        Text(title)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Toggle("", isOn: isOn)
                    .toggleStyle(SwitchToggleStyle(tint: color))
            }
            
            if isOn.wrappedValue {
                VStack(spacing: 16) {
                    HStack {
                        Image(systemName: "thermometer")
                            .foregroundColor(color)
                        Text("\(Int(temperature.wrappedValue))°C")
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.bold)
                        Spacer()
                        Text(currentUsage)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    CustomSlider2(value: temperature, range: range, color: color)
                }
                .transition(.opacity)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(radius: 8)
        )
        .animation(.spring(), value: isOn.wrappedValue)
    }
    
    private func modeButton(_ mode: ApplianceMode) -> some View {
        Button(action: { selectedMode = mode }) {
            VStack(spacing: 8) {
                Image(systemName: mode.icon)
                    .font(.title3)
                Text(mode.title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(selectedMode == mode ? mode.color.opacity(0.2) : Color.clear)
            .foregroundColor(selectedMode == mode ? mode.color : .primary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedMode == mode ? mode.color : Color.secondary.opacity(0.2))
            )
        }
    }
    
    private func actionButton(title: String, icon: String, color: Color) -> some View {
        Button(action: {}) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(color)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
    }
    
    private func monitorRow(title: String, value: String, icon: String, color: Color) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40)
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.headline)
        }
    }
}

struct CustomSlider2: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let color: Color
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.secondary.opacity(0.2))
                
                Rectangle()
                    .foregroundColor(color)
                    .frame(width: geometry.size.width * CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound)))
            }
        }
        .frame(height: 8)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    let ratio = gesture.location.x / gesture.translation.width
                    let newValue = Double(ratio) * (range.upperBound - range.lowerBound) + range.lowerBound
                    value = min(max(newValue, range.lowerBound), range.upperBound)
                }
        )
    }
}

enum ApplianceMode: CaseIterable {
    case eco, normal, boost, silent
    
    var title: String {
        switch self {
        case .eco: return "Ekonomi"
        case .normal: return "Normal"
        case .boost: return "Güçlü"
        case .silent: return "Sessiz"
        }
    }
    
    var icon: String {
        switch self {
        case .eco: return "leaf.fill"
        case .normal: return "sun.max.fill"
        case .boost: return "bolt.fill"
        case .silent: return "moon.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .eco: return .green
        case .normal: return .blue
        case .boost: return .orange
        case .silent: return .purple
        }
    }
}
