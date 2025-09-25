import SwiftUI

struct VerifyView: View {
    @State private var name: String = ""
    @State private var idCard: String = ""
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 205 / 255, green: 217 / 255, blue: 122 / 255),
                    Color(red: 137 / 255, green: 175 / 255, blue: 212 / 255),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            Image("verify-pet")
                .resizable()
                .frame(width: 272, height: 272)
                .padding(.bottom, 440)
                .padding(.trailing, 225)
            VStack {
                // Back button at the top
                /* HStack {
                    Button(action: {
                        coordinator.transitionToMain()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                            Text("返回")
                                .foregroundColor(.black)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Color.white.opacity(0.3)
                        )
                        .cornerRadius(20)
                    }
                    Spacer()
                }
                .padding(.horizontal, 32) */
                //.padding(.top, 16)

                Text("亲爱的玩家，根据法律法规和国家政策，游戏账号必须实名注册，否则无法体验游戏。为了更好的游戏。")
                    .font(.caption)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 315)
                    .hidden()
                Spacer()

                VStack(spacing: 24) {
                    VStack(spacing: 12) {
                        Text("实名认证")
                            .font(.system(size: 32))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.center)

                        Text(
                            "亲爱的玩家，根据法律法规和国家政策，游戏账号必须实名注册，否则无法体验游戏。为了更好的游戏体验，请尽快完成实名认证。"
                        )
                        .font(.system(size: 16))
                        .foregroundColor(.black.opacity(0.8))
                    }
                    VStack {
                        HStack(spacing: 0) {

                            Image(systemName: "person")
                                .padding()
                                .frame(
                                    minWidth: 50,
                                    maxWidth: 50,
                                    minHeight: 50,
                                    maxHeight: 50
                                )
                                .foregroundColor(Color.black)
                                .background(
                                    Color(
                                        red: 255 / 255,
                                        green: 255 / 255,
                                        blue: 255 / 255,
                                        opacity: 0.5
                                    )
                                )
                                .clipShape(
                                    UnevenRoundedRectangle(
                                        topLeadingRadius: 10,
                                        bottomLeadingRadius: 10,
                                        bottomTrailingRadius: 0,
                                        topTrailingRadius: 0
                                    )
                                )

                            TextField("姓名", text: $name)
                                .padding()
                                .padding(.leading, 0)
                                .frame(minHeight: 50, maxHeight: 50)
                                .background(
                                    Color(
                                        red: 255 / 255,
                                        green: 255 / 255,
                                        blue: 255 / 255,
                                        opacity: 0.5
                                    )
                                )
                                .clipShape(
                                    UnevenRoundedRectangle(
                                        topLeadingRadius: 0,
                                        bottomLeadingRadius: 0,
                                        bottomTrailingRadius: 10,
                                        topTrailingRadius: 10
                                    )
                                )
                        }
                        HStack(spacing: 0) {

                            Image("id-card")
                                .padding()
                                .frame(
                                    minWidth: 50,
                                    maxWidth: 50,
                                    minHeight: 50,
                                    maxHeight: 50
                                )
                                .foregroundColor(Color.black)
                                .background(
                                    Color(
                                        red: 255 / 255,
                                        green: 255 / 255,
                                        blue: 255 / 255,
                                        opacity: 0.5
                                    )
                                )
                                .clipShape(
                                    UnevenRoundedRectangle(
                                        topLeadingRadius: 10,
                                        bottomLeadingRadius: 10,
                                        bottomTrailingRadius: 0,
                                        topTrailingRadius: 0
                                    )
                                )

                            TextField("身份证号码", text: $idCard)
                                .padding()
                                .padding(.leading, 0)
                                .frame(minHeight: 50, maxHeight: 50)
                                .background(
                                    Color(
                                        red: 255 / 255,
                                        green: 255 / 255,
                                        blue: 255 / 255,
                                        opacity: 0.5
                                    )
                                )
                                .clipShape(
                                    UnevenRoundedRectangle(
                                        topLeadingRadius: 0,
                                        bottomLeadingRadius: 0,
                                        bottomTrailingRadius: 10,
                                        topTrailingRadius: 10
                                    )
                                )
                        }
                    }

                    Button(action: {
                        print("登录按钮被点击")
                        coordinator.transitionToMain()
                    }) {
                        Text("登录")
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                Color(
                                    red: 205 / 255, green: 217 / 255, blue: 122 / 255,
                                    opacity: 1)
                            )
                            .shadow(
                                color: Color.black.opacity(0.25),
                                radius: 4,
                                x: 0,
                                y: 2
                            )
                            .cornerRadius(10)
                    }
                    .buttonStyle(PlainButtonStyle())

                }.padding(.horizontal, 24).padding(.vertical, 36).frame(
                    maxWidth: 315
                ).background(
                    Color(
                        red: 255 / 255,
                        green: 255 / 255,
                        blue: 255 / 255,
                        opacity: 0.5
                    )
                )
                .cornerRadius(10)

                .shadow(
                    color: Color.black.opacity(0.25),
                    radius: 4,
                    x: 0,
                    y: 2
                )

                Spacer()
                Text("亲爱的玩家，根据法律法规和国家政策，游戏账号必须实名注册，否则无法体验游戏。为了更好的游戏。")
                    .font(.caption)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 315)
            }
            .padding()

        }.navigationBarBackButtonHidden(true).toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    coordinator.popAuth()
                }) {
                    Image(systemName: "chevron.left").foregroundColor(.black)
                }
            }
        }
    }
}

#Preview {
    VerifyView()
        .environmentObject(AppCoordinator())
}
