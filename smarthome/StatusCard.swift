//
//  StatusCard.swift
//  smarthome
//
//  Created by Ferhat Bozkurt on 22.12.2024.
//


import SwiftUI

struct StatusCard: View {
    let title: String
    let items: [StatusItemData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(.headline)
            
            HStack(spacing: 30) {
                ForEach(items, id: \.self) { item in
                    StatusItem(title: item.title, value: item.value, icon: item.icon)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}

struct StatusItem: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
            Text(value)
                .font(.subheadline)
                .bold()
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct StatusItemData: Hashable {
    let title: String
    let value: String
    let icon: String
}
