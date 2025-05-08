import SwiftUI

struct Settings: View {    // Not: Swift'te struct isimleri büyük harfle başlamalıdır
    @State private var isDarkMode = false
    @State private var isNotificationsEnabled = true
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.blue)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("ferhat")
                            .font(.headline)
                        Text("ferhat@example.com")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 8)
                }
                .padding(.vertical, 8)
            }
            
            Section(header: Text("Hesap Ayarları")
                .textCase(.uppercase)
                .font(.footnote)
                .foregroundColor(.blue)) {
                    
                NavigationLink(destination: Text("Profil Düzenle")) {
                    SettingsRow(icon: "person.fill",
                              iconColor: .blue,
                              title: "Profili Düzenle")
                }
                
                NavigationLink(destination: Text("Şifre Değiştir")) {
                    SettingsRow(icon: "lock.fill",
                              iconColor: .green,
                              title: "Şifre Değiştir")
                }
            }
            
            Section(header: Text("Tercihler")
                .textCase(.uppercase)
                .font(.footnote)
                .foregroundColor(.blue)) {
                    
                Toggle(isOn: $isNotificationsEnabled) {
                    SettingsRow(icon: "bell.fill",
                              iconColor: .purple,
                              title: "Bildirimler")
                }
                
                Toggle(isOn: $isDarkMode) {
                    SettingsRow(icon: "moon.fill",
                              iconColor: .indigo,
                              title: "Karanlık Mod")
                }
            }
            
            Section(header: Text("Hakkında")
                .textCase(.uppercase)
                .font(.footnote)
                .foregroundColor(.blue)) {
                    
                SettingsRow(icon: "star.fill",
                          iconColor: .orange,
                          title: "Uygulama Değerlendir")
                
                SettingsRow(icon: "doc.fill",
                          iconColor: .gray,
                          title: "Kullanım Koşulları")
                
                SettingsRow(icon: "lock.shield.fill",
                          iconColor: .red,
                          title: "Gizlilik Politikası")
            }
            
            Section {
                Button(action: {
                    // Çıkış işlemi
                }) {
                    HStack {
                        Spacer()
                        Text("Çıkış Yap")
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("Ayarlar")
    }
}

// Yardımcı view yapısı
struct SettingsRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.system(size: 20))
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.system(size: 16))
        }
    }
}

// Önizleme
struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Settings()
        }
    }
}
