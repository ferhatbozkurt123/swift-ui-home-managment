import SwiftUI

struct NotificationsView: View {
    @Binding var HomeGoal: Int
    @Environment(\.dismiss) var dismiss
    @State private var selectedFilter: NotificationType?
    @State private var showDeleteAlert = false
    @State private var notifications: [NotificationItem] = [
        NotificationItem(
            title: "Güvenlik Uyarısı",
            message: "Ön kapı açık bırakıldı. Lütfen kontrol edin.",
            time: "2 dakika önce",
            type: .security,
            isRead: false,
            priority: .high
        ),
        NotificationItem(
            title: "Enerji Tasarrufu",
            message: "Oturma odası ışıkları 2 saattir açık. Enerji tasarrufu için kapatmanız önerilir.",
            time: "15 dakika önce",
            type: .energy,
            isRead: false,
            priority: .medium
        ),
        NotificationItem(
            title: "Sıcaklık Uyarısı",
            message: "Yatak odası sıcaklığı 26°C'ye yükseldi. Klima otomatik olarak devreye girdi.",
            time: "1 saat önce",
            type: .temperature,
            isRead: true,
            priority: .medium
        ),
        NotificationItem(
            title: "Cihaz Güncellemesi",
            message: "Akıllı termostat için yeni güncelleme mevcut. Güvenlik yamaları içerir.",
            time: "3 saat önce",
            type: .system,
            isRead: true,
            priority: .low
        ),
        NotificationItem(
            title: "Hareket Algılandı",
            message: "Arka bahçede hareket algılandı. Kamera kaydı başlatıldı.",
            time: "4 saat önce",
            type: .security,
            isRead: true,
            priority: .high
        )
    ]
    
    // Gradient renkler
    let gradientBackground = LinearGradient(
        gradient: Gradient(colors: [Color("4158D0"), Color("C850C0")]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    var filteredNotifications: [NotificationItem] {
        guard let filter = selectedFilter else {
            return notifications
        }
        return notifications.filter { $0.type == filter }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground).edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Bildirim özeti
                    NotificationSummaryView(notifications: notifications)
                        .padding()
                    
                    // Filtre görünümü
                    NotificationFilterView(selectedFilter: $selectedFilter)
                        .padding(.horizontal)
                    
                    if filteredNotifications.isEmpty {
                        EmptyNotificationView()
                    } else {
                        List {
                            ForEach(filteredNotifications) { notification in
                                NotificationRow(notification: notification)
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                            deleteNotification(notification)
                                        } label: {
                                            Label("Sil", systemImage: "trash")
                                        }
                                        
                                        Button {
                                            toggleReadStatus(notification)
                                        } label: {
                                            Label(notification.isRead ? "Okunmadı" : "Okundu",
                                                  systemImage: notification.isRead ? "envelope" : "envelope.open")
                                        }
                                        .tint(.blue)
                                    }
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                }
            }
            .navigationTitle("Bildirimler")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: markAllAsRead) {
                        Text("Tümünü Okundu")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showDeleteAlert = true }) {
                        Text("Temizle")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.red)
                    }
                }
            }
            .alert("Tüm Bildirimleri Sil", isPresented: $showDeleteAlert) {
                Button("İptal", role: .cancel) { }
                Button("Sil", role: .destructive) {
                    clearAllNotifications()
                }
            } message: {
                Text("Tüm bildirimler silinecek. Bu işlem geri alınamaz.")
            }
        }
    }
    
    // MARK: - Helper Functions
    
    func deleteNotification(_ notification: NotificationItem) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications.remove(at: index)
        }
    }
    
    func toggleReadStatus(_ notification: NotificationItem) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index].isRead.toggle()
        }
    }
    
    func markAllAsRead() {
        for index in notifications.indices {
            notifications[index].isRead = true
        }
    }
    
    func clearAllNotifications() {
        notifications.removeAll()
    }
}

// MARK: - Supporting Views

struct NotificationSummaryView: View {
    let notifications: [NotificationItem]
    
    var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Okunmamış")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(unreadCount)")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Toplam")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(notifications.count)")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct EmptyNotificationView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "bell.slash")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("Bildirim Bulunmuyor")
                .font(.headline)
            
            Text("Yeni bildirimler geldiğinde burada görünecek.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Models

struct NotificationItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let time: String
    let type: NotificationType
    var isRead: Bool
    let priority: Priority
    
    enum Priority {
        case low, medium, high
        
        var color: Color {
            switch self {
            case .low: return .blue
            case .medium: return .orange
            case .high: return .red
            }
        }
    }
}

enum NotificationType: String, CaseIterable {
    case security = "Güvenlik"
    case energy = "Enerji"
    case temperature = "Sıcaklık"
    case system = "Sistem"
    
    var icon: String {
        switch self {
        case .security: return "shield.fill"
        case .energy: return "bolt.fill"
        case .temperature: return "thermometer"
        case .system: return "gear"
        }
    }
    
    var color: Color {
        switch self {
        case .security: return .red
        case .energy: return .yellow
        case .temperature: return .orange
        case .system: return .blue
        }
    }
}

struct NotificationRow: View {
    let notification: NotificationItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(notification.type.color.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: notification.type.icon)
                        .foregroundColor(notification.type.color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(notification.title)
                            .font(.system(size: 16, weight: .semibold))
                        
                        if !notification.isRead {
                            Circle()
                                .fill(notification.priority.color)
                                .frame(width: 8, height: 8)
                        }
                        
                        Spacer()
                        
                        Text(notification.time)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(notification.message)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
        }
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
    }
}

struct NotificationFilterView: View {
    @Binding var selectedFilter: NotificationType?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterButton(title: "Tümü", isSelected: selectedFilter == nil) {
                    selectedFilter = nil
                }
                
                ForEach(NotificationType.allCases, id: \.self) { type in
                    FilterButton(title: type.rawValue, isSelected: selectedFilter == type) {
                        selectedFilter = type
                    }
                }
            }
            .padding(.vertical, 8)
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
                .animation(.easeInOut, value: isSelected)
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView(HomeGoal: .constant(0))
    }
}
