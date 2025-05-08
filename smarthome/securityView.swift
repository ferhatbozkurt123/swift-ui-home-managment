import SwiftUI

struct securityView: View {
    @State private var isCCTVOn = true
    @State private var isAlarmArmed = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Security")
                .font(.largeTitle)
                .bold()

            Toggle("CCTV On/Off", isOn: $isCCTVOn)
                .toggleStyle(SwitchToggleStyle(tint: .red))
                .padding()

            Toggle("Alarm Armed", isOn: $isAlarmArmed)
                .toggleStyle(SwitchToggleStyle(tint: .orange))
                .padding()

            Spacer()
        }
        .padding()
        .navigationTitle("Security")
    }
}
