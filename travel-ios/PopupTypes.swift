import SwiftUI

enum PopupType {
    case basket
    case suitcase
    case currency
    case settings
    case search
    case messages
}

struct MessageRowView: View {
    let title: String
    let content: String
    let time: String
    let type: String
    let isUnread: Bool

    var body: some View {
        Button(action: {
            // Handle message tap
        }) {
            HStack(spacing: 12) {
                // Message type icon
                ZStack {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 40, height: 40)

                    Image(systemName: getMessageIcon(for: type))
                        .font(.system(size: 24))
                        .foregroundColor(.black)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(.subheadline)
                            .fontWeight(isUnread ? .semibold : .regular)
                            .foregroundColor(.black)

                        Spacer()

                        /* Text(time)
                            .font(.caption)
                            .foregroundColor(.gray) */
                    }

                    Text(content)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }

                /* if isUnread {
                    Circle()
                        .fill(Color.red)
                        .frame(width: 8, height: 8)
                } */
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                Color(
                    red: 255 / 255,
                    green: 255 / 255,
                    blue: 255 / 255,
                    opacity: isUnread ? 0.9 : 0.5
                )
            )
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func getMessageColor(for type: String) -> Color {
        switch type {
        case "system":
            return Color.blue
        case "user":
            return Color.green
        case "assistant":
            return Color.orange
        case "support":
            return Color.purple
        default:
            return Color.gray
        }
    }

    private func getMessageIcon(for type: String) -> String {
        switch type {
        case "system":
            return "heart"
        case "user":
            return "ellipsis.message"
        case "assistant":
            return "bell"
        case "support":
            return "headphones"
        default:
            return "envelope.fill"
        }
    }
}

struct MessagesPopupView: View {
    let onClose: () -> Void
    @EnvironmentObject var coordinator: AppCoordinator

    private let sampleMessages = [
        ("系统通知", "您的会员即将到期，请及时续费", "1小时前", "system"),
        ("小红", "谢谢你的分享，非常有用！", "2小时前", "user"),
        ("旅行助手", "您的行程已更新，请查看详情", "3小时前", "assistant"),
        /* ("张伟", "明天一起去爬山怎么样？", "5小时前", "user"),
        ("系统通知", "您获得了新的成就徽章", "1天前", "system"),
        ("李娜", "照片拍得很棒！", "2天前", "user"),
        ("客服", "您的问题已解决，如有其他疑问请联系我们", "3天前", "support"),
        ("小明", "这个地方我也去过，风景真不错", "1周前", "user"), */
    ]

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                        .onTapGesture {
                            onClose()
                        }
                    Spacer()
                    ZStack {
                        Color(
                            red: 255 / 255,
                            green: 255 / 255,
                            blue: 255 / 255,
                            opacity: 0.5
                        )
                        .cornerRadius(10)
                        Image(systemName: "ellipsis.message")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: 40, maxHeight: 40)
                }.padding()

                // Messages content
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(0..<sampleMessages.count, id: \.self) { index in
                            let message = sampleMessages[index]
                            MessageRowView(
                                title: message.0,
                                content: message.1,
                                time: message.2,
                                type: message.3,
                                isUnread: index < 3
                            )
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
