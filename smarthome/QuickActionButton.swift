import SwiftUI

struct QuickActionButton: View {
    let title: String
    let icon: String
    
    var body: some View {
        Button(action: {}) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title3)
                Text(title)
                    .font(.caption)
            }
            .padding()
            .frame(width: 100)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .foregroundColor(.primary)
        }
    }
}
