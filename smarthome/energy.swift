import SwiftUI
import Charts

struct energy: View {
    @State private var progress: CGFloat = 0.5
    @State private var isAnimating = false
    @State private var selectedTimeFrame = "Günlük"
    @State private var showingSettings = false
    @State private var isOptimizing = false
    @State private var energyGoal: Double = 5.0
    @State private var selectedTab = "Kullanım"
    
    private let timeFrames = ["Günlük", "Haftalık", "Aylık", "Yıllık"]
    private let gradient = LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
    private let usageData = [4.2, 3.8, 5.1, 4.7, 3.9, 4.3, 4.8]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Üst Bilgi Kartı
                    headerCard
                    
                    // Ana Enerji Göstergesi
                    mainEnergyCard
                    
                    // Sekme Görünümü
                    tabView
                    
                    // Grafik Kartı
                    chartCard
                    
                    // Hızlı Eylemler
                    quickActionsGrid7
                    
                    // Detaylı İstatistikler
                    statsCard
                    
                    // Enerji Tasarruf İpuçları
                    tipsCard
                }
                .padding()
            }
            .navigationTitle("Enerji Merkezi")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSettings.toggle() }) {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                SettingsView1(energyGoal: $energyGoal)
            }
        }
    }
    
    private var headerCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text("Toplam Tüketim")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("\(Int(progress * 100)) kWh")
                    .font(.title)
                    .fontWeight(.bold)
            }
            
            Spacer()
            
            Menu {
                ForEach(timeFrames, id: \.self) { frame in
                    Button(frame) {
                        selectedTimeFrame = frame
                    }
                }
            } label: {
                HStack {
                    Text(selectedTimeFrame)
                    Image(systemName: "chevron.down")
                }
                .padding(8)
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private var mainEnergyCard: some View {
        VStack(spacing: 25) {
            ZStack {
                // Arka Plan Animasyonlu Halkalar
                ForEach(0..<3) { i in
                    Circle()
                        .stroke(gradient.opacity(0.3), lineWidth: 30)
                        .scaleEffect(isAnimating ? 1 + CGFloat(i) * 0.1 : 1)
                        .opacity(isAnimating ? 0 : 0.3)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true)
                                .delay(Double(i) * 0.2),
                            value: isAnimating
                        )
                }
                
                // Ana Halka
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [.blue, .purple, .pink, .blue]),
                            center: .center
                        ),
                        style: StrokeStyle(
                            lineWidth: 30,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 1, dampingFraction: 0.8), value: progress)
                
                // Merkez İçeriği
                VStack(spacing: 12) {
                    Text("\(Int(progress * 100))")
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundStyle(gradient)
                    
                    Text("kWh Kullanım")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Image(systemName: "leaf.fill")
                            .foregroundColor(.green)
                        Text("Verimlilik: %\(Int(progress * 100))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(height: 280)
            .onAppear { isAnimating = true }
            
            // Kontrol Butonları
            HStack(spacing: 20) {
                controlButton7(
                    title: "Optimize Et",
                    icon: "bolt.circle.fill",
                    action: { isOptimizing.toggle() }
                )
                .overlay {
                    if isOptimizing {
                        ProgressView()
                            .tint(.white)
                    }
                }
                
                controlButton7(
                    title: "Analiz",
                    icon: "chart.bar.xaxis",
                    action: { }
                )
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemBackground))
                .shadow(radius: 10, x: 0, y: 5)
        )
    }
    
    private var tabView: some View {
        Picker("", selection: $selectedTab) {
            Text("Kullanım").tag("Kullanım")
            Text("Maliyet").tag("Maliyet")
            Text("Tasarruf").tag("Tasarruf")
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
    
    private var chartCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Enerji Trendleri")
                .font(.headline)
            
            Chart {
                ForEach(Array(usageData.enumerated()), id: \.offset) { index, value in
                    LineMark(
                        x: .value("Gün", index),
                        y: .value("kWh", value)
                    )
                    .foregroundStyle(gradient)
                    
                    AreaMark(
                        x: .value("Gün", index),
                        y: .value("kWh", value)
                    )
                    .foregroundStyle(gradient.opacity(0.1))
                }
            }
            .frame(height: 200)
            
            HStack {
                Text("Ortalama:")
                    .foregroundColor(.secondary)
                Text("\(usageData.reduce(0, +) / Double(usageData.count), specifier: "%.1f") kWh")
                    .fontWeight(.semibold)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private var quickActionsGrid7: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
            ForEach(QuickAction7.allCases, id: \.self) { action in
                quickActionButton7(action)
            }
        }
    }
    
    private var statsCard: some View {
        VStack(spacing: 20) {
            ForEach(["Günlük", "Haftalık", "Aylık"], id: \.self) { period in
                statRow7(
                    title: "\(period) Ortalama",
                    value: "\(Double.random(in: 3...7).rounded(to: 1)) kWh",
                    icon: "chart.bar.fill",
                    color: .blue
                )
                if period != "Aylık" { Divider() }
            }
        }
        .padding(20)
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    private var tipsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Enerji Tasarruf İpuçları")
                .font(.headline)
            
            ForEach(energySavingTips, id: \.self) { tip in
                HStack(spacing: 12) {
                    Image(systemName: "lightbulb.fill")
                        .foregroundColor(.yellow)
                    Text(tip)
                        .font(.subheadline)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
    }
    
    // Yardımcı Görünümler ve Fonksiyonlar...
    private let energySavingTips = [
        "Kullanılmayan cihazları kapatın",
        "LED ampuller kullanın",
        "Doğal ışıktan faydalanın",
        "Akıllı prizler kullanın"
    ]
}

// Ayarlar Görünümü
struct SettingsView1: View {
    @Environment(\.dismiss) var dismiss
    @Binding var energyGoal: Double
    
    var body: some View {
        NavigationView {
            Form {
                Section("Hedefler") {
                    HStack {
                        Text("Günlük Enerji Hedefi")
                        Spacer()
                        Text("\(energyGoal, specifier: "%.1f") kWh")
                    }
                    Slider(value: $energyGoal, in: 1...10, step: 0.5)
                }
                
                Section("Bildirimler") {
                    Toggle("Günlük Rapor", isOn: .constant(true))
                    Toggle("Hedef Aşımı", isOn: .constant(true))
                    Toggle("Tasarruf İpuçları", isOn: .constant(true))
                }
            }
            .navigationTitle("Ayarlar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Tamam") { dismiss() }
                }
            }
        }
    }
}

extension Double {
    func rounded(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


enum QuickAction7: CaseIterable {
    case optimize, schedule, report, settings
    
    var title: String {
        switch self {
        case .optimize: return "Optimize Et"
        case .schedule: return "Programla"
        case .report: return "Raporlar"
        case .settings: return "Ayarlar"
        }
    }
    
    var icon: String {
        switch self {
        case .optimize: return "bolt.circle.fill"
        case .schedule: return "clock.fill"
        case .report: return "chart.bar.fill"
        case .settings: return "gearshape.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .optimize: return .blue
        case .schedule: return .purple
        case .report: return .orange
        case .settings: return .gray
        }
    }
}


private func controlButton7(title: String, icon: String, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        HStack {
            Image(systemName: icon)
            Text(title)
                .fontWeight(.semibold)
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 50)
        
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

private func quickActionButton7(_ action: QuickAction7) -> some View {
    VStack {
        Image(systemName: action.icon)
            .font(.title2)
            .foregroundColor(.white)
            .frame(width: 50, height: 50)
            .background(action.color)
            .clipShape(Circle())
        
        Text(action.title)
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .padding()
    .frame(maxWidth: .infinity)
    .background(Color(.systemBackground))
    .cornerRadius(15)
    .shadow(radius: 5)
}

private func statRow7(title: String, value: String, icon: String, color: Color) -> some View {
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
            .foregroundColor(.primary)
    }
}
