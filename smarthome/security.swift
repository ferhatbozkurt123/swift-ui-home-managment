//
//  security.swift
//  smarthome
//
//  Created by Ferhat Bozkurt on 27.12.2024.
//

import SwiftUI

struct Security: View {
    // MARK: - Properties
    @State private var isSystemArmed = false
    @State private var selectedCamera = 0
    @State private var showEmergencyAlert = false
    @State private var selectedTab = 0
    @State private var motionDetected = false
    @State private var doorStatus = true // true = kilitli
    
    let cameras = ["Ön Kapı", "Arka Bahçe", "Garaj", "Yan Bahçe"]
    let recentEvents = [
        "Ön kapıda hareket algılandı - 14:23",
        "Garaj kapısı açıldı - 13:45",
        "Arka bahçede hareket algılandı - 12:30",
        "Pencere sensörü tetiklendi - 11:15"
    ]
    
    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                securityStatusCard
                cameraSection
                sensorStatusSection
                recentEventsSection
            }
            .padding(.vertical)
        }
        .navigationTitle("Güvenlik")
        .background(Color(.systemGroupedBackground))
        .alert("Acil Durum", isPresented: $showEmergencyAlert) {
            Button("112'yi Ara", role: .destructive) {
                // Acil durum çağrısı
            }
            Button("İptal", role: .cancel) {}
        } message: {
            Text("Acil durum servisleri aranacak. Devam etmek istiyor musunuz?")
        }
    }
    
    // MARK: - Security Status Card
    private var securityStatusCard: some View {
        VStack(spacing: 20) {
            // Status Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                isSystemArmed ? .green.opacity(0.3) : .red.opacity(0.3),
                                isSystemArmed ? .green.opacity(0.1) : .red.opacity(0.1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 120, height: 120)
                
                Image(systemName: isSystemArmed ? "lock.fill" : "lock.open.fill")
                    .font(.system(size: 50))
                    .foregroundColor(isSystemArmed ? .green : .red)
                    .symbolEffect(.bounce, options: .repeating)
            }
            
            // System Control
            VStack(spacing: 15) {
                HStack {
                    Text("Sistem Durumu")
                        .font(.headline)
                    Spacer()
                    Text(isSystemArmed ? "Aktif" : "Devre Dışı")
                        .foregroundColor(isSystemArmed ? .green : .red)
                        .font(.subheadline)
                        .bold()
                }
                
                Toggle("Güvenlik Sistemi", isOn: $isSystemArmed)
                    .toggleStyle(SwitchToggleStyle(tint: .green))
                
                Button(action: { showEmergencyAlert = true }) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("ACİL DURUM")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
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
    
    // MARK: - Camera Section
    private var cameraSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Güvenlik Kameraları")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(Array(cameras.enumerated()), id: \.element) { index, camera in
                        CameraButton(
                            title: camera,
                            isSelected: selectedCamera == index,
                            isActive: true,
                            action: { selectedCamera = index }
                        )
                    }
                }
                .padding(.horizontal)
            }
            
            // Camera Preview
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color(.systemGray6))
                    .frame(height: 200)
                
                Image(systemName: "video.fill")
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
                
                VStack {
                    Spacer()
                    Text(cameras[selectedCamera])
                        .font(.caption)
                        .padding(8)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Sensor Status Section
    private var sensorStatusSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Sensör Durumları")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 15) {
                SensorStatusRow(
                    title: "Hareket Sensörü",
                    status: motionDetected ? "Hareket Algılandı!" : "Normal",
                    icon: "sensor.fill",
                    color: motionDetected ? .red : .green
                )
                
                SensorStatusRow(
                    title: "Kapı Durumu",
                    status: doorStatus ? "Kilitli" : "Açık",
                    icon: "door.left.hand.closed",
                    color: doorStatus ? .green : .red
                )
                
                SensorStatusRow(
                    title: "Pencere Sensörleri",
                    status: "Tümü Kapalı",
                    icon: "window.vertical.closed",
                    color: .green
                )
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .padding(.horizontal)
        }
    }
    
    // MARK: - Recent Events Section
    private var recentEventsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Son Olaylar")
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 15) {
                ForEach(recentEvents, id: \.self) { event in
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.orange)
                        
                        Text(event)
                            .font(.subheadline)
                        
                        Spacer()
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            .padding(.horizontal)
        }
    }
}

// MARK: - Supporting Views
struct CameraButton: View {
    let title: String
    let isSelected: Bool
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: "video.fill")
                    .font(.system(size: 24))
                    .symbolEffect(.pulse)
                
                Text(title)
                    .font(.caption)
                    .bold()
                
                Circle()
                    .fill(isActive ? Color.green : Color.red)
                    .frame(width: 8, height: 8)
            }
            .padding()
            .frame(minWidth: 100)
            .background(isSelected ? Color.blue : Color(.systemGray6))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(12)
            .animation(.spring(), value: isSelected)
        }
    }
}
struct SensorStatusRow: View {
    let title: String
    let status: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 30)
                .symbolEffect(.pulse)
            
            Text(title)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(status)
                .font(.subheadline)
                .foregroundColor(color)
                .bold()
        }
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        Security()
    }
}
