import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
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
            VStack {

                Text("亲爱的玩家，根据法律法规和国家政策，游戏账号必须实名注册，否则无法体验游戏。为了更好的游戏。")
                    .font(.caption)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .hidden()
                Spacer()
                VStack(spacing: 24) {
                    VStack {
                        ZStack(alignment: .leading) {

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

                                TextField("用户名", text: $username)
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
                            }.frame(maxWidth: 315)
                        }.overlay(alignment: .trailing) {
                            Image("login-pet")
                                .resizable()
                                .frame(width: 126, height: 126)
                                .padding(.trailing, 20)
                                .padding(.bottom, 150)
                        }
                        HStack(spacing: 0) {
                            Image(systemName: "lock")
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

                            SecureField("密码", text: $password)
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

                            Button("忘记密码") {
                                print("Forgot password tapped")
                            }
                            .padding()
                            .frame(minHeight: 50, maxHeight: 50)
                            .foregroundColor(.black)
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
                        }.frame(maxWidth: 315)
                    }
                    VStack {
                        Button(action: {
                            print("Login")
                            print("用户名: \(username)")
                            print("密码: \(password)")
                            coordinator.pushAuth(.verify)
                        }) {
                            Text("登录")
                                .foregroundColor(.black)
                                //.frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 48)
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

                        Button(action: {
                            print("Register")
                        }) {
                            Text("注册")
                                .foregroundColor(.black)
                                //.frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 48)
                                .background(
                                    Color.clear
                                )
                                .shadow(
                                    color: Color.black.opacity(0.25),
                                    radius: 4,
                                    x: 0,
                                    y: 2
                                )
                                .cornerRadius(10)
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                Spacer()
                Text("亲爱的玩家，根据法律法规和国家政策，游戏账号必须实名注册，否则无法体验游戏。为了更好的游戏。")
                    .font(.caption)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 315)

            }.padding()

        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppCoordinator())
}
