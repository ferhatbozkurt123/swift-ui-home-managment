import SwiftUI
import Charts

struct Home: View {
    @State private var isRotating = false
    @State private var selectedMode = "Home"
    @State private var temperature = 23
    @State private var showQuickActions = false
    @State private var selectedTab = "all"
    @State private var HomeGoal: Int = 0  // veya ihtiyacınız olan tip

    // Custom colors
    let primaryGradient = LinearGradient(
        gradient: Gradient(colors: [Color(hex: "4158D0"), Color(hex: "C850C0")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    let glassBackground = Color(.systemBackground).opacity(0.7)
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 35) {
                    
                    WeatherTimeCard2()
                    // Animated Header with Glass Effect
                    VStack(spacing: 15) {
                        ZStack {
                            // Animated Background Circles
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color(hex: "4158D0").opacity(0.2),
                                            Color(hex: "C850C0").opacity(0.1)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 200, height: 200)
                                .blur(radius: 2)
                            
                            Circle()
                                .fill(Color(hex: "4158D0").opacity(0.1))
                                .frame(width: 160, height: 160)
                                .offset(x: -30, y: 20)
                                .blur(radius: 3)
                            
                            // Rotating House Icon with 3D Effect
                            Image(systemName: "house.circle.fill")
                                .resizable()
                                .frame(width: 110, height: 110)
                                .foregroundStyle(primaryGradient)
                                .rotationEffect(Angle(degrees: isRotating ? 360 : 0))
                                .animation(
                                    .easeInOut(duration: 3)
                                    .repeatForever(autoreverses: false),
                                    value: isRotating
                                )
                                .shadow(color: Color(hex: "4158D0").opacity(0.5), radius: 15, x: 0, y: 8)
                        }
                        
                        Text("Hoşgeldiniz")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(primaryGradient)
                        
                        Text("Akıllı ev cihazlarınızı kontrol edin")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Quick Actions
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                           
                            
                            NavigationLink(destination: Security()) {
                                QuickActionButton5(
                                    icon: "shield.fill",
                                    title: "Güvenlik",
                                    isActive: true,
                                    color: .blue,
                                    isNavigationLink: true
                                )
                            }
                            
                           
                            NavigationLink(destination: AllLight()) {
                                        QuickActionButton5(
                                            icon: "lightbulb.fill",
                                            title: "Tüm Işıklar",
                                            isActive: true,
                                            color: .yellow,
                                            isNavigationLink: true
                                        )
                                    }
                            
                            NavigationLink(destination: ThermostatView()) {
                                        QuickActionButton5(
                                            icon: "thermometer",
                                            title: "Termostat",
                                            isActive: true,
                                            color: .mint,
                                            isNavigationLink: true
                                        )
                                    }
                           
                            
                           
                            
                            NavigationLink(destination: AllDoors()) {
                                QuickActionButton5(
                                    icon: "lock.fill",
                                    title: "Kapılar",
                                    isActive: true,
                                    color: .green,
                                    isNavigationLink: true
                                )
                            }
                            NavigationLink(destination: Entertainment()) {
                                QuickActionButton5(
                                    icon: "party.fill",
                                    title: "Eğlence",
                                    isActive: true,
                                    color: .purple,
                                    isNavigationLink: true
                                )
                            }
                          
                            
                          
                        }
                        .padding(.horizontal)
                    }

                    
                    // Status Card with Glass Effect
                    VStack(spacing: 20) {
                        // Mevcut başlık kısmı
                        HStack {
                            
                            Spacer()
                            Button(action: { showQuickActions.toggle() }) {
                                Text("Detaylar")
                                    .foregroundStyle(primaryGradient)
                                    .font(.system(size: 16, weight: .medium, design: .rounded))
                            }
                        }
                        
                        // Tüketim Grafikleri
                        VStack(spacing: 15) {
                            // Elektrik Tüketimi
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "bolt.fill")
                                        .foregroundColor(.yellow)
                                    Text("Elektrik Tüketimi")
                                        .font(.system(size: 14, weight: .medium))
                                    Spacer()
                                    Text("324 kWh")
                                        .font(.system(size: 14, weight: .bold))
                                }
                                
                                // Yeni Elektrik Grafiği
                                Chart {
                                    ForEach(elektrikVerileri) { veri in
                                        LineMark(
                                            x: .value("Gün", veri.gun),
                                            y: .value("Tüketim", veri.deger)
                                        )
                                        .foregroundStyle(Color.yellow.gradient)
                                        
                                        AreaMark(
                                            x: .value("Gün", veri.gun),
                                            y: .value("Tüketim", veri.deger)
                                        )
                                        .foregroundStyle(Color.yellow.opacity(0.1))
                                    }
                                }
                                .frame(height: 100)
                                
                                // Günlük etiketler
                                HStack(spacing: 12) {
                                    ForEach(["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"], id: \.self) { gun in
                                        Text(gun)
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.yellow.opacity(0.1))
                            .cornerRadius(15)
                            
                            // Su Tüketimi
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "drop.fill")
                                        .foregroundColor(.blue)
                                    Text("Su Tüketimi")
                                        .font(.system(size: 14, weight: .medium))
                                    Spacer()
                                    Text("12.3 m³")
                                        .font(.system(size: 14, weight: .bold))
                                }
                                
                                // Yeni Su Grafiği
                                Chart {
                                    ForEach(suVerileri) { veri in
                                        BarMark(
                                            x: .value("Gün", veri.gun),
                                            y: .value("Tüketim", veri.deger)
                                        )
                                        .foregroundStyle(Color.blue.gradient)
                                    }
                                }
                                .frame(height: 100)
                                
                                // Günlük etiketler
                                HStack(spacing: 12) {
                                    ForEach(["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"], id: \.self) { gun in
                                        Text(gun)
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(15)
                            
                            // Doğalgaz Tüketimi
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Image(systemName: "flame.fill")
                                        .foregroundColor(.orange)
                                    Text("Doğalgaz Tüketimi")
                                        .font(.system(size: 14, weight: .medium))
                                    Spacer()
                                    Text("156 m³")
                                        .font(.system(size: 14, weight: .bold))
                                }
                                
                                // Yeni Doğalgaz Grafiği
                                Chart {
                                    ForEach(dogalgazVerileri) { veri in
                                        LineMark(
                                            x: .value("Gün", veri.gun),
                                            y: .value("Tüketim", veri.deger)
                                        )
                                        .foregroundStyle(Color.orange.gradient)
                                        
                                        PointMark(
                                            x: .value("Gün", veri.gun),
                                            y: .value("Tüketim", veri.deger)
                                        )
                                        .foregroundStyle(Color.orange)
                                    }
                                }
                                .frame(height: 100)
                                
                                // Günlük etiketler
                                HStack(spacing: 12) {
                                    ForEach(["Pzt", "Sal", "Çar", "Per", "Cum", "Cmt", "Paz"], id: \.self) { gun in
                                        Text(gun)
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(15)
                        }

                        
                        // Mevcut mod seçimi
                        HStack(spacing: 20) {
                            ModeButton5(title: "Ev", icon: "house.fill", isSelected: selectedMode == "Home") {
                                withAnimation { selectedMode = "Home" }
                            }
                            ModeButton5(title: "Dışarı", icon: "airplane", isSelected: selectedMode == "Away") {
                                withAnimation { selectedMode = "Away" }
                            }
                            ModeButton5(title: "Gündüz", icon: "sun.max.fill", isSelected: selectedMode == "Day") {
                                withAnimation { selectedMode = "Day" }
                            }
                            ModeButton5(title: "Gece", icon: "moon.stars.fill", isSelected: selectedMode == "Night") {
                                withAnimation { selectedMode = "Night" }
                            }
                        }
                       

                        .padding(.horizontal)
                        
                        // Mevcut durum göstergeleri
                        HStack(spacing: 30) {
                            StatusItem2(icon: "thermometer", title: "\(temperature)°C", subtitle: "Sıcaklık")
                            StatusItem2(icon: "humidity.fill", title: "45%", subtitle: "Nem")
                            StatusItem2(icon: "lightbulb.fill", title: "3", subtitle: "Açık Cihaz")
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 25)
                            .fill(glassBackground)
                            .background(.ultraThinMaterial)
                            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal)
                    // Room Filter Tabs
                    HStack(spacing: 20) {
                        FilterTab(title: "Tümü", isSelected: selectedTab == "all") {
                            withAnimation { selectedTab = "all" }
                        }
                        FilterTab(title: "Yaşam", isSelected: selectedTab == "living") {
                            withAnimation { selectedTab = "living" }
                        }
                        FilterTab(title: "Yatak", isSelected: selectedTab == "bed") {
                            withAnimation { selectedTab = "bed" }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Enhanced Room Grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 20) {
                        NavigationLink(destination: LivingRoom()) {
                            RoomCard3(icon: "tv.fill", title: "Oturma Odası", status: "2 cihaz açık")
                        }
                        
                        NavigationLink(destination: Kitchen()) {
                            RoomCard3(icon: "cup.and.saucer.fill", title: "Mutfak", status: "Tüm cihazlar kapalı")
                        }
                        
                        NavigationLink(destination: Bedroom()) {
                            RoomCard3(icon: "bed.double.fill", title: "Yatak Odası", status: "1 cihaz açık")
                        }
                        
                        NavigationLink(destination: Bathroom()) {
                            RoomCard3(icon: "drop.fill", title: "Banyo", status: "Tüm cihazlar kapalı")
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "line.horizontal.3")
                            .foregroundStyle(primaryGradient)
                    }
                }
                
                 
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: NotificationsView(HomeGoal: $HomeGoal)) {
                        Image(systemName: "bell.badge.fill")
                            .foregroundStyle(primaryGradient)
                            .overlay(
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 6, y: -6)
                            )
                    }
                }
            }
            .onAppear {
                isRotating = true
            }
        }
    }
}

// Quick Action Button
struct QuickActionButton5: View {
    let icon: String
    let title: String
    let isActive: Bool
    let color: Color
    var isNavigationLink: Bool = false
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                color.opacity(isActive ? 0.3 : 0.1),
                                color.opacity(isActive ? 0.1 : 0.05)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(isActive ? color : .gray)
                    .symbolEffect(.bounce)
            }
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isActive ? .primary : .secondary)
        }
        .frame(width: 80)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(
                    color: Color.black.opacity(0.1),
                    radius: 5,
                    x: 0,
                    y: 2
                )
        )
        .opacity(isActive ? 1 : 0.7)
    }
}


// Filter Tab
struct FilterTab: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold, design: .rounded))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(
                            isSelected ?
                            AnyShapeStyle(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "4158D0"), Color(hex: "C850C0")]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            ) :
                            AnyShapeStyle(Color.clear)
                        )

                )
                .foregroundColor(isSelected ? .white : .secondary)
        }
    }
}

// Previous components remain the same (ModeButton, RoomCard, StatusItem2, Color extension)
// ModeButton düzeltmesi
struct ModeButton5: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                Text(title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(
                        isSelected ?
                        AnyShapeStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "4158D0"), Color(hex: "C850C0")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        ) :
                        AnyShapeStyle(Color(.systemGray6))
                    )

            )
            .foregroundColor(isSelected ? .white : .primary)
            .shadow(color: isSelected ? Color(hex: "4158D0").opacity(0.3) : Color.clear, radius: 5, x: 0, y: 3)
        }
    }
}

struct RoomCard3: View {
    let icon: String
    let title: String
    let status: String
    
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "4158D0"), Color(hex: "C850C0")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 70, height: 70)
                .background(
                    Circle()
                        .fill(Color(hex: "4158D0").opacity(0.1))
                )
            
            Text(title)
                .font(.system(size: 16, weight: .bold, design: .rounded))
            
            Text(status)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

struct StatusItem2: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "4158D0"), Color(hex: "C850C0")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            Text(title)
                .font(.system(size: 16, weight: .bold, design: .rounded))
            Text(subtitle)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
        }
    }
}

// Helper extension for hex colors (remains the same)
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


struct WeatherTimeCard2: View {
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
#Preview {
    NavigationView {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                QuickActionButton5(icon: "lightbulb.fill", title: "Tüm Işıklar", isActive: true, color: .yellow)
                QuickActionButton5(icon: "tv.fill", title: "TV", isActive: false, color: .blue)
                QuickActionButton5(icon: "thermometer", title: "Klima", isActive: true, color: .mint)
                QuickActionButton5(icon: "lock.fill", title: "Kapılar", isActive: true, color: .green)
                NavigationLink(destination: Security()) {
                    QuickActionButton5(icon: "shield.fill", title: "Güvenlik", isActive: true, color: .blue, isNavigationLink: true)
                }
            }
            .padding()
        }
    }
}
struct TuketimVeri: Identifiable {
    let id = UUID()
    let gun: String
    let deger: Double
}

// Örnek veriler
let elektrikVerileri = [
    TuketimVeri(gun: "Pzt", deger: 45),
    TuketimVeri(gun: "Sal", deger: 52),
    TuketimVeri(gun: "Çar", deger: 48),
    TuketimVeri(gun: "Per", deger: 50),
    TuketimVeri(gun: "Cum", deger: 53),
    TuketimVeri(gun: "Cmt", deger: 42),
    TuketimVeri(gun: "Paz", deger: 40)
]

let suVerileri = [
    TuketimVeri(gun: "Pzt", deger: 1.8),
    TuketimVeri(gun: "Sal", deger: 1.6),
    TuketimVeri(gun: "Çar", deger: 2.0),
    TuketimVeri(gun: "Per", deger: 1.7),
    TuketimVeri(gun: "Cum", deger: 1.9),
    TuketimVeri(gun: "Cmt", deger: 1.5),
    TuketimVeri(gun: "Paz", deger: 1.4)
]

let dogalgazVerileri = [
    TuketimVeri(gun: "Pzt", deger: 22),
    TuketimVeri(gun: "Sal", deger: 25),
    TuketimVeri(gun: "Çar", deger: 20),
    TuketimVeri(gun: "Per", deger: 23),
    TuketimVeri(gun: "Cum", deger: 21),
    TuketimVeri(gun: "Cmt", deger: 19),
    TuketimVeri(gun: "Paz", deger: 18)
]
