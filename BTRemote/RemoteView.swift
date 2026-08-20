import SwiftUI

struct RemoteView: View {
    let goToSetup: () -> Void

    @Environment(\.hid) private var hid
    @AppStorage(AppSettings.developerModeKey) private var developerMode = false

    var body: some View {
        if hid.isActive || developerMode {
            controls
        } else {
            NotConnectedView(
                icon: "gamecontroller",
                goToSetup: goToSetup
            )
        }
    }

    private var controls: some View {
        HStack(spacing: 8) {

            oceanButton(
                key: .menuLeft,
                icon: "chevron.left",
                title: "上一页"
            )

            oceanButton(
                key: .power,
                icon: "power",
                title: "待机"
            )

            oceanButton(
                key: .menuRight,
                icon: "chevron.right",
                title: "下一页"
            )
        }
        .padding(10)
    }

    private func oceanButton(
        key: ConsumerKey,
        icon: String,
        title: String
    ) -> some View {

        HoldButton(
            onPress: {
                hid.sendConsumer(
                    ConsumerReport(key: key)
                )
            },
            onRelease: {
                hid.sendConsumer(.zero)
            },
            background: {
                RoundedRectangle(cornerRadius: 14)
                    .fill(groupFill)
            },
            label: {
                VStack(spacing: 5) {

                    Image(systemName: icon)
                        .font(
                            .system(
                                size: 25,
                                weight: .semibold
                            )
                        )

                    Text(title)
                        .font(.caption)
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity
                )
            }
        )
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .accessibilityLabel(Text(title))
    }
}

#if DEBUG
#Preview {
    RemoteView(goToSetup: {})
}
#endif
