import SwiftUI

// OtherRoomsView için TabItem desteği eklendi
struct OtherRoomsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Üst banner
                    RoomHeaderBanner(
                        roomName: "Diğer Alanlar",
                        iconName: "ellipsis.circle.fill",
                        backgroundColor: .gray
                    )
                    
                    // Diğer alanlar listesi
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Tüm Alanlar")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            OtherRoomCard(title: "Depo", icon: "archivebox.fill", color: .purple)
                            OtherRoomCard(title: "Çamaşırlık", icon: "washer.fill", color: .blue)
                            OtherRoomCard(title: "Kiler", icon: "cabinet.fill", color: .brown)
                            OtherRoomCard(title: "Garaj", icon: "car.fill", color: .gray)
                            OtherRoomCard(title: "Teras", icon: "sun.max.fill", color: .orange)
                            OtherRoomCard(title: "Hobi Odası", icon: "paintbrush.fill", color: .pink)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                .padding()
            }
            .navigationTitle("Diğer Alanlar")
            .background(Color(.systemGroupedBackground))
        }
    }
}



struct OtherRoomCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 45, height: 45)
                .background(color)
                .cornerRadius(10)
            
            Text(title)
                .font(.headline)
            
            Spacer()
            
            Text("23°")
                .foregroundColor(.gray)
                .font(.subheadline)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
