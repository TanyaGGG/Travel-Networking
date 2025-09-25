import SwiftUI

struct TreeHouseView: View {
    @State private var name: String = ""
    @State private var idCard: String = ""
    @State private var isButtonsMinimized1: Bool = false

    // Popup callback passed from MainTabView
    let onPopupShow: (PopupType) -> Void

    var body: some View {
        ZStack {
            // Main content
            ZStack {
                Text("TreeHouse")
                VStack {
                    HStack {
                        Spacer()
                        HStack {
                            Spacer()
                            HStack {
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        isButtonsMinimized1.toggle()
                                    }
                                }) {
                                    Image(
                                        systemName: isButtonsMinimized1
                                            ? "chevron.left" : "chevron.right"
                                    )

                                    .padding(12)
                                    .background(
                                        Color.white.opacity(0.1)
                                    )
                                    .cornerRadius(10)
                                }.buttonStyle(PlainButtonStyle())
                                if !isButtonsMinimized1 {
                                    Button(action: {
                                        onPopupShow(.basket)
                                    }) {
                                        ZStack {
                                            Color(
                                                red: 255 / 255,
                                                green: 255 / 255,
                                                blue: 255 / 255,
                                                opacity: 0.5
                                            )
                                            .cornerRadius(10)
                                            Image(systemName: "basket")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.black)
                                        }
                                        .frame(maxWidth: 40, maxHeight: 40)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    Button(action: {
                                        onPopupShow(.suitcase)
                                    }) {
                                        ZStack {
                                            Color(
                                                red: 255 / 255,
                                                green: 255 / 255,
                                                blue: 255 / 255,
                                                opacity: 0.5
                                            )
                                            .cornerRadius(10)
                                            Image(
                                                systemName: "suitcase"
                                            )
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.black)
                                        }
                                        .frame(maxWidth: 40, maxHeight: 40)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    Button(action: {
                                        onPopupShow(.currency)
                                    }) {
                                        ZStack {
                                            Color(
                                                red: 255 / 255,
                                                green: 255 / 255,
                                                blue: 255 / 255,
                                                opacity: 0.5
                                            )
                                            .cornerRadius(10)
                                            Image(
                                                systemName: "chineseyuanrenminbisign.square"
                                            )
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.black)
                                        }
                                        .frame(maxWidth: 40, maxHeight: 40)
                                    }.buttonStyle(PlainButtonStyle())
                                }
                            }

                        }

                    }
                    Spacer()
                }.padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Image("home-bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    TreeHouseView(
        onPopupShow: { _ in }
    )
}
