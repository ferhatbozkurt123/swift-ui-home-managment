import SwiftUI

struct Garden: View {
    // MARK: - Properties
    @State private var isSprinklerOn = false
    @State private var selectedZone = 0
    @State private var soilMoisture = 75.0
    @State private var isAnimating = false
    
    let zones = ["Ön Bahçe", "Arka Bahçe", "Yan Bahçe"]
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 25) {
                    mainControlCard
                    zoneSelection
                    gardenStats
                }
            }
            .navigationTitle("Bahçe Kontrolü")
            .background(Color(.systemGroupedBackground))
        }
    }
    
    // MARK: - Main Control Card
    private var mainControlCard: some View {
        VStack(spacing: 20) {
            // Sulama Durumu İkonu
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                isSprinklerOn ? .green.opacity(0.3) : .gray.opacity(0.3),
                                isSprinklerOn ? .green.opacity(0.1) : .gray.opacity(0.1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: "drop.fill")
                    .font(.system(size: 50))
                    .foregroundColor(isSprinklerOn ? .green : .gray)
                    .rotationEffect(.degrees(isSprinklerOn ? 0 : 180))
                    .offset(y: isAnimating && isSprinklerOn ? -10 : 0)
                    .animation(
                        isSprinklerOn ?
                            .easeInOut(duration: 1).repeatForever(autoreverses: true) : .default,
                        value: isAnimating
                    )
                    .onAppear { isAnimating = true }
            }
            
            // Sulama Kontrolü
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "spray.fill")
                        .foregroundColor(.green)
                    Text("Sulama Sistemi")
                        .font(.headline)
                }
                
                HStack {
                    Text(isSprinklerOn ? "Aktif" : "Kapalı")
                        .foregroundColor(isSprinklerOn ? .green : .secondary)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Toggle("", isOn: $isSprinklerOn)
                        .toggleStyle(SwitchToggleStyle(tint: .green))
                        .frame(maxWidth: 80)
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
        .padding()
    }
    
    // MARK: - Zone Selection
    private var zoneSelection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Sulama Bölgeleri")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(Array(zones.enumerated()), id: \.element) { index, zone in
                        ZoneButton(
                            title: zone,
                            icon: zoneIcon(for: index),
                            isSelected: selectedZone == index,
                            action: {
                                withAnimation(.spring()) {
                                    selectedZone = index
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    // MARK: - Garden Stats
    private var gardenStats: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Bahçe Durumu")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 15) {
                GardenStatRow(
                    title: "Toprak Nemi",
                    value: "\(Int(soilMoisture))%",
                    icon: "humidity.fill",
                    color: soilMoistureColor
                )
                GardenStatRow(
                    title: "Son Sulama",
                    value: "2 saat önce",
                    icon: "clock.fill",
                    color: .green
                )
                GardenStatRow(
                    title: "Sonraki Sulama",
                    value: "Yarın 06:00",
                    icon: "calendar",
                    color: .green
                )
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
        }
        .padding(.horizontal)
    }
    
    // MARK: - Helper Functions
    private func zoneIcon(for index: Int) -> String {
        switch index {
        case 0: return "house.fill"
        case 1: return "tree.fill"
        case 2: return "leaf.fill"
        default: return "flowerpot.fill"
        }
    }
    
    private var soilMoistureColor: Color {
        switch soilMoisture {
        case 0...30: return .red
        case 31...60: return .orange
        default: return .green
        }
    }
}

// MARK: - Supporting Views
struct ZoneButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                Text(title)
                    .font(.system(.subheadline, design: .rounded))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.green : Color(.systemGray6))
            )
            .foregroundColor(isSelected ? .white : .primary)
            .animation(.spring(), value: isSelected)
        }
    }
}

struct GardenStatRow: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)
                .symbolEffect(.bounce, options: .repeating)
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.headline)
                .foregroundColor(color)
        }
    }
}

// MARK: - Preview
#Preview {
    Garden()
}
