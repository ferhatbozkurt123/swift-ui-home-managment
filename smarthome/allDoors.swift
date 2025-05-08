import SwiftUI

// MARK: - Ana Görünüm
struct AllDoors: View {
    @State private var sections: [DoorSection] = [
        DoorSection(title: "Kapılar", icon: "door.left.hand.closed", items: [
            DoorItem(name: "Ana Giriş", type: .door, isLocked: true, isOpen: false, batteryLevel: 85, lastActivity: "10 dk önce"),
            DoorItem(name: "Arka Kapı", type: .door, isLocked: true, isOpen: false, batteryLevel: 90, lastActivity: "25 dk önce"),
            DoorItem(name: "Garaj Kapısı", type: .door, isLocked: true, isOpen: false, batteryLevel: 95, lastActivity: "1 saat önce")
        ]),
        DoorSection(title: "Pencereler", icon: "window.vertical", items: [
            DoorItem(name: "Salon Penceresi", type: .window, isLocked: true, isOpen: false, batteryLevel: 75, lastActivity: "15 dk önce"),
            DoorItem(name: "Mutfak Penceresi", type: .window, isLocked: true, isOpen: false, batteryLevel: 80, lastActivity: "30 dk önce"),
            DoorItem(name: "Yatak Odası Penceresi", type: .window, isLocked: true, isOpen: false, batteryLevel: 88, lastActivity: "45 dk önce"),
            DoorItem(name: "Çalışma Odası Penceresi", type: .window, isLocked: true, isOpen: false, batteryLevel: 92, lastActivity: "2 saat önce")
        ])
    ]
    
    @State private var selectedFilter = 0
    let filters = ["Tümü", "Açık", "Kapalı"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                StatusCard11(sections: sections)
                    .padding(.horizontal)
                
                Picker("Filtre", selection: $selectedFilter) {
                    ForEach(0..<filters.count, id: \.self) { index in
                        Text(filters[index])
                            .tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        QuickActionButton11(title: "Tümünü Kilitle", icon: "lock.fill", color: .blue)
                        QuickActionButton11(title: "Tümünü Aç", icon: "lock.open.fill", color: .green)
                        QuickActionButton11(title: "Gece Modu", icon: "moon.fill", color: .purple)
                        QuickActionButton11(title: "Dışarıdayım", icon: "house.fill", color: .orange)
                    }
                    .padding(.horizontal)
                }
                
                ForEach($sections) { $section in
                    SectionCard(section: $section)
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("Kapılar & Pencereler")
        .background(Color(.systemGray6).ignoresSafeArea())
    }
}

// MARK: - Durum Kartı
struct StatusCard11: View {
    let sections: [DoorSection]
    
    var body: some View {
        VStack(spacing: 25) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Güvenlik Durumu")
                        .font(.headline)
                    Text(securityStatus)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(securityColor)
                }
                Spacer()
                CircularSecurityIndicator(percentage: securityPercentage)
            }
            
            HStack(spacing: 20) {
                SecurityMetricView(title: "Açık", value: openItems, icon: "door.left.hand.open", color: .green)
                SecurityMetricView(title: "Kapalı", value: closedItems, icon: "door.left.hand.closed", color: .blue)
                SecurityMetricView(title: "Kilitli Değil", value: unlockedItems, icon: "lock.open", color: .red)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 15, x: 0, y: 5)
        )
    }
    
    private var openItems: Int {
        sections.reduce(0) { $0 + $1.items.filter(\.isOpen).count }
    }
    
    private var closedItems: Int {
        sections.reduce(0) { $0 + $1.items.filter { !$0.isOpen }.count }
    }
    
    private var unlockedItems: Int {
        sections.reduce(0) { $0 + $1.items.filter { !$0.isLocked }.count }
    }
    
    private var securityPercentage: Double {
        let total = Double(sections.reduce(0) { $0 + $1.items.count })
        let secure = Double(sections.reduce(0) { $0 + $1.items.filter { $0.isLocked && !$0.isOpen }.count })
        return secure / total
    }
    
    private var securityStatus: String {
        switch securityPercentage {
        case 1: return "Güvenli"
        case 0.6...0.99: return "Dikkat"
        default: return "Riskli"
        }
    }
    
    private var securityColor: Color {
        switch securityPercentage {
        case 1: return .green
        case 0.6...0.99: return .orange
        default: return .red
        }
    }
}

// MARK: - Bölüm Kartı
struct SectionCard: View {
    @Binding var section: DoorSection
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: section.icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text(section.title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("\(section.items.filter(\.isOpen).count)/\(section.items.count) Açık")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
            }
            
            VStack(spacing: 12) {
                ForEach($section.items) { $item in
                    DoorItemRow(item: $item)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 8)
        )
    }
}

// MARK: - Yardımcı Görünümler
struct CircularSecurityIndicator: View {
    let percentage: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 8)
            
            Circle()
                .trim(from: 0, to: percentage)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .green]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 8, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            
            Text("\(Int(percentage * 100))%")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
        }
        .frame(width: 70, height: 70)
    }
}

struct SecurityMetricView: View {
    let title: String
    let value: Int
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text("\(value)")
                .font(.headline)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(color.opacity(0.1))
        )
    }
}

struct QuickActionButton11: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .foregroundColor(.white)
            .frame(width: 100, height: 100)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(color: color.opacity(0.3), radius: 10, x: 0, y: 5)
            )
        }
    }
}

struct DoorItemRow: View {
    @Binding var item: DoorItem
    
    var body: some View {
        HStack(spacing: 15) {
            ZStack {
                Circle()
                    .fill(item.isOpen ? Color.green.opacity(0.2) : Color.gray.opacity(0.2))
                    .frame(width: 45, height: 45)
                
                Image(systemName: item.statusIcon)
                    .font(.title2)
                    .foregroundColor(item.statusColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.medium)
                
                HStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image(systemName: "battery.75")
                        Text("\(item.batteryLevel)%")
                    }
                    
                    Text("•")
                    
                    Text(item.lastActivity)
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: { item.isLocked.toggle() }) {
                    Image(systemName: item.isLocked ? "lock.fill" : "lock.open.fill")
                        .foregroundColor(item.isLocked ? .blue : .red)
                        .font(.title3)
                }
                
                Toggle("", isOn: $item.isOpen)
                    .labelsHidden()
                    .tint(.green)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 5)
        )
    }
}

// MARK: - Veri Modelleri
struct DoorSection: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    var items: [DoorItem]
}

enum DoorType {
    case door
    case window
}

struct DoorItem: Identifiable {
    let id = UUID()
    let name: String
    let type: DoorType
    var isLocked: Bool
    var isOpen: Bool
    let batteryLevel: Int
    let lastActivity: String
    
    var statusIcon: String {
        switch type {
        case .door:
            return isOpen ? "door.left.hand.open" : "door.left.hand.closed"
        case .window:
            return isOpen ? "window.vertical.open" : "window.vertical"
        }
    }
    
    var statusColor: Color {
        isOpen ? .green : .gray
    }
}

#Preview {
    NavigationView {
        AllDoors()
    }
}
