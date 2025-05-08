import SwiftUI

struct Entertainment: View {
    @State private var devices: [EntertainmentSection] = [
        // TV & Video Sistemleri
        EntertainmentSection(title: "TV & Video", icon: "tv.fill", items: [
            EntertainmentDevice(
                name: "Salon TV",
                type: .tv,
                isOn: false,
                currentContent: "Netflix - Stranger Things",
                volume: 35,
                source: "HDMI 1",
                features: ["4K", "HDR", "Dolby Vision"],
                recentContent: ["Stranger Things", "Wednesday", "The Witcher"]
            ),
            EntertainmentDevice(
                name: "Yatak Odası TV",
                type: .tv,
                isOn: false,
                currentContent: "YouTube",
                volume: 25,
                source: "Smart TV",
                features: ["Full HD", "Smart TV"],
                recentContent: ["YouTube", "Prime Video", "Disney+"]
            ),
            EntertainmentDevice(
                name: "Sinema Projektörü",
                type: .projector,
                isOn: false,
                currentContent: "HDMI 2",
                volume: 0,
                source: "HDMI 2",
                features: ["4K", "3D", "120Hz"],
                recentContent: []
            )
        ]),
        
        // Ses Sistemleri
        EntertainmentSection(title: "Müzik", icon: "speaker.wave.3.fill", items: [
            EntertainmentDevice(
                name: "Salon Ses Sistemi",
                type: .speaker,
                isOn: false,
                currentContent: "Spotify - Chill Mix",
                volume: 40,
                features: ["Dolby Atmos", "Surround Sound"],
                recentContent: ["Chill Mix", "Party Playlist", "Jazz Collection"]
            ),
            EntertainmentDevice(
                name: "Mutfak Hoparlör",
                type: .speaker,
                isOn: false,
                currentContent: "Radio - Power FM",
                volume: 30,
                features: ["Bluetooth 5.0", "Waterproof"],
                recentContent: ["Power FM", "Morning Mix", "Cooking Playlist"]
            ),
            EntertainmentDevice(
                name: "Bahçe Hoparlörleri",
                type: .speaker,
                isOn: false,
                currentContent: "Spotify",
                volume: 45,
                features: ["Weatherproof", "Stereo Pair"],
                recentContent: ["Garden Party Mix", "Summer Hits", "BBQ Playlist"]
            )
        ]),
        
        // Oyun Sistemleri
        EntertainmentSection(title: "Oyun", icon: "gamecontroller.fill", items: [
            EntertainmentDevice(
                name: "PlayStation 5",
                type: .gaming,
                isOn: false,
                currentContent: "FIFA 24",
                volume: 50,
                features: ["4K Gaming", "Ray Tracing", "DualSense"],
                recentContent: ["FIFA 24", "God of War", "Spider-Man 2"]
            ),
            EntertainmentDevice(
                name: "Xbox Series X",
                type: .gaming,
                isOn: false,
                currentContent: "Forza Horizon",
                volume: 45,
                features: ["4K Gaming", "Quick Resume", "Game Pass"],
                recentContent: ["Forza", "Halo", "Starfield"]
            )
        ]),
        
        // Akıllı Aydınlatma
        EntertainmentSection(title: "Ambiyans", icon: "lightbulb.fill", items: [
            EntertainmentDevice(
                name: "Salon Işıkları",
                type: .lighting,
                isOn: false,
                currentContent: "Film Modu",
                volume: 50 ,
                features: ["RGB", "Sync with TV", "Scene Control"],
                scenes: ["Film Modu", "Parti", "Dinlenme", "Oyun"]
            ),
            
            EntertainmentDevice(
                name: "LED Şerit",
                type: .lighting,
                isOn: false,
                currentContent: "Gökkuşağı Efekti",
                volume: 30 ,
                features: ["RGBW", "Music Sync", "Custom Effects"],
                scenes: ["Gökkuşağı", "Dalga", "Gradient", "Müzik"]
            )
        ])
    ]
    
    @State private var selectedDevice: EntertainmentDevice?
    @State private var showingDeviceControl = false
    @State private var selectedScene: String = "Normal"
    @State private var isEditMode = false
    
    let scenes = ["Normal", "Film Gecesi", "Parti Modu", "Oyun Modu", "Romantik", "Dinlenme"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Sahne Seçici
                ScenePickerView(selectedScene: $selectedScene, scenes: scenes)
                
                // Aktif Cihazlar Özeti
                ActiveDevicesSummary(devices: devices)
                
                // Hızlı Kontroller
                EnhancedQuickControlsView()
                
                // Medya Önerileri
                MediaSuggestionsView()
                
                // Cihaz Bölümleri
                ForEach($devices) { $section in
                    EnhancedDeviceSectionView(section: $section) { device in
                        selectedDevice = device
                        showingDeviceControl = true
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Eğlence Merkezi")
        .navigationBarItems(
            trailing: Button(isEditMode ? "Bitti" : "Düzenle") {
                isEditMode.toggle()
            }
        )
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemGray6), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            ).ignoresSafeArea()
        )
        .sheet(isPresented: $showingDeviceControl) {
            if let device = selectedDevice {
                EnhancedDeviceControlView(device: .constant(device))
            }
        }
    }
}

struct ScenePickerView: View {
    @Binding var selectedScene: String
    let scenes: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(scenes, id: \.self) { scene in
                    SceneButton(
                        title: scene,
                        isSelected: scene == selectedScene,
                        action: { selectedScene = scene }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

struct SceneButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.medium)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.blue : Color(.systemGray5))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

struct ActiveDevicesSummary: View {
    let devices: [EntertainmentSection]
    
    var activeDevices: Int {
        devices.reduce(0) { $0 + $1.items.filter(\.isOn).count }
    }
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text("Aktif Cihazlar")
                    .font(.headline)
                Text("\(activeDevices) cihaz çalışıyor")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            CircularProgressView(
                percentage: Double(activeDevices) / Double(totalDevices),
                color: .blue
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10)
        )
    }
    
    var totalDevices: Int {
        devices.reduce(0) { $0 + $1.items.count }
    }
}

struct EnhancedQuickControlsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Hızlı Kontroller")
                .font(.title3)
                .fontWeight(.bold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                QuickControlButton12(
                    icon: "power", title: "Tümünü Kapat",
                    color: .red,
                    gradient: true
                )
                QuickControlButton12(
                    icon: "film.fill",
                    title: "Film Modu",
                    color: .purple,
                    gradient: true
                )
                QuickControlButton12(
                    icon: "music.note",
                    title: "Parti Modu",
                    color: .blue,
                    gradient: true
                )
                QuickControlButton12(
                    icon: "gamecontroller.fill",
                    title: "Oyun Modu",
                    color: .green,
                    gradient: true
                )
                QuickControlButton12(
                    icon: "moon.fill",
                    title: "Gece Modu",
                    color: .indigo,
                    gradient: true
                )
                QuickControlButton12(
                    icon: "leaf.fill",
                    title: "Enerji Tasarrufu",
                    color: .orange,
                    gradient: true
                )
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10)
        )
    }
}

struct MediaSuggestionsView: View {
    let suggestions = [
        ("Netflix'te Trend", "netflix.logo", ["Stranger Things", "Wednesday", "The Crown"]),
        ("Spotify'da Popüler", "spotify.logo", ["Top 50", "Chill Mix", "Party Hits"]),
        ("Yeni Oyunlar", "gamecontroller.fill", ["FIFA 24", "Spider-Man 2", "Starfield"])
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Öneriler")
                .font(.title3)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(suggestions, id: \.0) { suggestion in
                        SuggestionCard(
                            title: suggestion.0,
                            icon: suggestion.1,
                            items: suggestion.2
                        )
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10)
        )
    }
}

struct SuggestionCard: View {
    let title: String
    let icon: String
    let items: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(title)
                    .font(.headline)
            }
            
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(width: 200)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray6))
        )
    }
}

// MARK: - Veri Modelleri
struct EntertainmentDevice: Identifiable {
    let id = UUID()
    let name: String
    let type: DeviceType
    var isOn: Bool
    var currentContent: String
    var volume: Int
    var source: String?
    var features: [String]
    var recentContent: [String] = []
    var scenes: [String]?
    var lastUsed: Date = Date()
    var favoriteInputs: [String] = []
    var equalizer: EqualizerSettings?
}

struct EqualizerSettings {
    var bass: Double = 0
    var treble: Double = 0
    var balance: Double = 0
    var preset: String = "Normal"
}

enum DeviceType {
    case tv
    case speaker
    case gaming
    case projector
    case lighting
    
    var icon: String {
        switch self {
        case .tv: return "tv.fill"
        case .speaker: return "speaker.wave.3.fill"
        case .gaming: return "gamecontroller.fill"
        case .projector: return "video.fill"
        case .lighting: return "lightbulb.fill"
        }
    }
}

// MARK: - Gelişmiş Cihaz Kontrol Görünümü
struct EnhancedDeviceControlView: View {
    @Binding var device: EntertainmentDevice
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedTab = 0
    @State private var showingSettings = false
    @State private var isEditing = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Cihaz Durumu Kartı
                DeviceStatusCard(device: $device)
                
                // Tab Seçici
                Picker("Kontrol", selection: $selectedTab) {
                    Text("Ana").tag(0)
                    Text("Medya").tag(1)
                    Text("Ayarlar").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                
                // Tab İçeriği
                TabView(selection: $selectedTab) {
                    MainControlView(device: $device)
                        .tag(0)
                    
                    MediaControlView(device: $device)
                        .tag(1)
                    
                    SettingsView(device: $device)
                        .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle(device.name)
            .navigationBarItems(
                leading: Button("Kapat") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button(action: {
                    showingSettings.toggle()
                }) {
                    Image(systemName: "gear")
                }
            )
        }
    }
}

struct DeviceStatusCard: View {
    @Binding var device: EntertainmentDevice
    
    var body: some View {
        VStack(spacing: 15) {
            // Cihaz İkonu ve Durum
            HStack {
                Image(systemName: device.type.icon)
                    .font(.system(size: 40))
                    .foregroundColor(device.isOn ? .blue : .gray)
                
                VStack(alignment: .leading) {
                    Text(device.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(device.isOn ? "Açık" : "Kapalı")
                        .foregroundColor(device.isOn ? .green : .gray)
                }
                
                Spacer()
                
                PowerButton3(
                    isOn: $device.isOn,
                    action: {
                        // Burada yapılacak işlemler
                        // Örnek: cihazın durumunu değiştirme işlemleri
                    }
                )

            }
            
            if device.isOn {
                Divider()
                
                // Mevcut İçerik
                HStack {
                    Image(systemName: "play.circle.fill")
                    Text("Şu an oynatılıyor:")
                        .font(.subheadline)
                    Text(device.currentContent)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                // Özellikler
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(device.features, id: \.self) { feature in
                            FeatureTag(text: feature)
                        }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10)
        )
        .padding(.horizontal)
    }
}

struct MainControlView: View {
    @Binding var device: EntertainmentDevice
    @State private var volume: Double
    
    init(device: Binding<EntertainmentDevice>) {
        self._device = device
        self._volume = State(initialValue: Double(device.wrappedValue.volume))
    }
    
    var body: some View {
        VStack(spacing: 30) {
            // Ses Kontrolü
            VStack(spacing: 10) {
                Text("Ses Seviyesi: \(Int(volume))%")
                    .font(.headline)
                
                HStack {
                    Image(systemName: "speaker.fill")
                    Slider(value: $volume, in: 0...100) { changed in
                        if !changed {
                            device.volume = Int(volume)
                        }
                    }
                    Image(systemName: "speaker.wave.3.fill")
                }
                .padding(.horizontal)
            }
            
            // Hızlı Kontroller
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 20) {
                QuickActionButton12(
                    title: "Sessiz",
                    icon: "speaker.slash.fill",
                    action: { volume = 0 }
                )
                
                QuickActionButton12(
                    title: "Favori",
                    icon: "star.fill",
                    action: { /* Favori ayarları */ }
                )
                
                if device.type == .tv || device.type == .projector {
                    QuickActionButton12(
                        title: "Kaynak",
                        icon: "arrow.up.right.video.fill",
                        action: { /* Kaynak değiştir */ }
                    )
                    
                    QuickActionButton12(
                        title: "Görüntü",
                        icon: "photo.fill",
                        action: { /* Görüntü ayarları */ }
                    )
                }
            }
            .padding(.horizontal)
            
            // Son Kullanılanlar
            if !device.recentContent.isEmpty {
                VStack(alignment: .leading) {
                    Text("Son Kullanılanlar")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(device.recentContent, id: \.self) { content in
                                RecentContentButton(title: content) {
                                    device.currentContent = content
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct MediaControlView: View {
    @Binding var device: EntertainmentDevice
    
    var body: some View {
        VStack(spacing: 30) {
            // Medya Bilgisi
            VStack(spacing: 15) {
                Image(systemName: "music.note")
                    .font(.system(size: 50))
                    .foregroundColor(.blue)
                
                Text(device.currentContent)
                    .font(.title3)
                    .fontWeight(.medium)
            }
            
            // Medya Kontrolleri
            HStack(spacing: 40) {
                Button(action: { /* Önceki */ }) {
                    Image(systemName: "backward.fill")
                        .font(.title)
                }
                
                Button(action: { /* Oynat/Duraklat */ }) {
                    Image(systemName: "play.fill")
                        .font(.system(size: 40))
                }
                
                Button(action: { /* Sonraki */ }) {
                    Image(systemName: "forward.fill")
                        .font(.title)
                }
            }
            .foregroundColor(.primary)
            
            // İlerleme Çubuğu
            ProgressView(value: 0.4)
                .padding(.horizontal)
            
            // Ek Kontroller
            HStack(spacing: 30) {
                MediaControlButton(icon: "shuffle", action: {})
                MediaControlButton(icon: "repeat", action: {})
                MediaControlButton(icon: "list.bullet", action: {})
                MediaControlButton(icon: "speaker.wave.2.fill", action: {})
            }
        }
        .padding()
    }
}

struct SettingsView: View {
    @Binding var device: EntertainmentDevice
    @State private var equalizer: EqualizerSettings
    
    init(device: Binding<EntertainmentDevice>) {
        self._device = device
        self._equalizer = State(initialValue: device.wrappedValue.equalizer ?? EqualizerSettings())
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Ekolayzer
                if device.type == .speaker || device.type == .tv {
                    EqualizerView(settings: $equalizer)
                }
                
                // Özellikler Listesi
                FeaturesListView(features: device.features)
                
                // Cihaz Bilgileri
                DeviceInfoView(device: device)
            }
            .padding()
        }
    }
}

// MARK: - Yardımcı Görünümler
struct PowerButton3: View {
    @Binding var isOn: Bool
    let action: () -> Void // Eksik parametre ekleyelim
    
    init(isOn: Binding<Bool>, action: @escaping () -> Void) {
        self._isOn = isOn
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            isOn.toggle()
            action()
        }) {
            Circle()
                .fill(isOn ? Color.green : Color.gray)
                .frame(width: 44, height: 44)
                .overlay(
                    Image(systemName: "power")
                        .foregroundColor(.white)
                )
        }
    }
}


struct FeatureTag: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.blue.opacity(0.1))
            )
            .foregroundColor(.blue)
    }
}

struct QuickActionButton12: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray6))
            )
        }
    }
}

struct RecentContentButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color(.systemGray6))
                )
        }
    }
}

struct MediaControlButton: View {
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.primary)
        }
    }
}

struct EqualizerView: View {
    @Binding var settings: EqualizerSettings
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Ekolayzer")
                .font(.headline)
            
            VStack(spacing: 20) {
                SliderView(value: $settings.bass, title: "Bas")
                SliderView(value: $settings.treble, title: "Tiz")
                SliderView(value: $settings.balance, title: "Balans")
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray6))
        )
    }
}

struct SliderView: View {
    @Binding var value: Double
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.subheadline)
            
            Slider(value: $value, in: -10...10)
        }
    }
}

struct FeaturesListView: View {
    let features: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Özellikler")
                .font(.headline)
            
            ForEach(features, id: \.self) { feature in
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text(feature)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray6))
        )
    }
}

struct DeviceInfoView: View {
    let device: EntertainmentDevice
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Cihaz Bilgileri")
                .font(.headline)
            
            InfoRow(title: "Son Kullanım", value: device.lastUsed.formatted())
            InfoRow(title: "Tip", value: String(describing: device.type))
            if let source = device.source {
                InfoRow(title: "Kaynak", value: source)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray6))
        )
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
        }
    }
}

struct CircularProgressView: View {
    let percentage: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 8)
            Circle()
                .trim(from: 0, to: CGFloat(percentage))
                .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: percentage)
            
            Text("\(Int(percentage * 100))%")
                .font(.caption)
                .bold()
        }
        .frame(width: 50, height: 50)
    }
}
struct QuickControlButton12: View {
    let icon: String
    let title: String
    let color: Color
    let gradient: Bool
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                Group {
                    if gradient {
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        color
                    }
                }
            )
            .cornerRadius(15)
            .foregroundColor(.white)
        }
    }
}


// MARK: - EntertainmentSection Modeli
struct EntertainmentSection: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    var items: [EntertainmentDevice]
}

// MARK: - EnhancedDeviceSectionView
struct EnhancedDeviceSectionView: View {
    @Binding var section: EntertainmentSection
    let onDeviceSelected: (EntertainmentDevice) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            // Başlık
            HStack {
                Image(systemName: section.icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                Text(section.title)
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                // Aktif cihaz sayısı
                Text("\(section.items.filter(\.isOn).count) aktif")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            // Cihaz listesi
            VStack(spacing: 12) {
                ForEach($section.items) { $device in
                    DeviceRowView(device: $device)
                        .onTapGesture {
                            onDeviceSelected(device)
                        }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 10)
        )
    }
}

// MARK: - DeviceRowView
struct DeviceRowView: View {
    @Binding var device: EntertainmentDevice
    
    var body: some View {
        HStack(spacing: 15) {
            // Cihaz ikonu
            Image(systemName: device.type.icon)
                .font(.title3)
                .foregroundColor(device.isOn ? .blue : .gray)
            
            // Cihaz bilgileri
            VStack(alignment: .leading, spacing: 4) {
                Text(device.name)
                    .fontWeight(.medium)
                if device.isOn {
                    Text(device.currentContent)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Güç düğmesi
            PowerButton3(isOn: $device.isOn) {
                // Cihaz durumu değiştiğinde yapılacak işlemler
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemGray6))
        )
        .animation(.easeInOut, value: device.isOn)
    }
}

// MARK: - Önizleme
struct EnhancedDeviceSectionView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleSection = EntertainmentSection(
            title: "TV & Video",
            icon: "tv.fill",
            items: [
                EntertainmentDevice(
                    name: "Salon TV",
                    type: .tv,
                    isOn: true,
                    currentContent: "Netflix - Stranger Things",
                    volume: 35,
                    source: "HDMI 1",
                    features: ["4K", "HDR", "Dolby Vision"],
                    recentContent: ["Stranger Things", "Wednesday", "The Witcher"]
                ),
                EntertainmentDevice(
                    name: "Yatak Odası TV",
                    type: .tv,
                    isOn: false,
                    currentContent: "YouTube",
                    volume: 25,
                    source: "Smart TV",
                    features: ["Full HD", "Smart TV"],
                    recentContent: ["YouTube", "Prime Video", "Disney+"]
                )
            ]
        )
        
        EnhancedDeviceSectionView(
            section: .constant(sampleSection),
            onDeviceSelected: { _ in }
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
