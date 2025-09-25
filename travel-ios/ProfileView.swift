import SwiftUI

struct ProfileView: View {
    let onShowGoalView: (() -> Void)?
    let onLogout: () -> Void
    let onShowSettings: (() -> Void)?
    let onShowMessages: (() -> Void)?
    @State private var name: String = ""
    @State private var idCard: String = ""
    @State private var selectedTab: Int = 0
    @State private var selectedCardTab: String = "成长历程"

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
                HStack {
                    Spacer()
                    HStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                onShowMessages?()
                            }) {
                                ZStack {
                                    Image(
                                        systemName: "ellipsis.message"
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
                                onShowSettings?()
                            }) {
                                ZStack {

                                    Image(
                                        systemName: "gearshape"
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
                HStack(spacing: 16) {
                    Image("prof-pic")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 88, height: 88)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    Color(
                                        red: 255 / 255, green: 255 / 255,
                                        blue: 255 / 255,
                                        opacity: 0.5),
                                    lineWidth: 2)
                        )

                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .top) {
                            Text("Tanya")
                                .font(.title)
                            Button(action: {
                                print("Edit")
                            }) {
                                ZStack {
                                    Image(systemName: "pencil").resizable()
                                        .scaledToFit()
                                        .frame(width: 12, height: 12)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(maxWidth: 12, maxHeight: 12)
                        }
                        HStack(alignment: .top) {
                            Text("UID: 123456789")
                                .font(.caption)
                            Button(action: {
                                print("Document")
                            }) {
                                ZStack {
                                    Image(systemName: "document.on.document").resizable()
                                        .scaledToFit()
                                        .frame(width: 12, height: 12)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .frame(maxWidth: 12, maxHeight: 12)
                        }
                    }

                    Spacer()
                    VStack {
                        Button(action: {
                            // TODO: Add logout action
                        }) {
                            Text("开通会员")
                                .font(.headline)

                                .foregroundColor(.black)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            Color(
                                                red: 255 / 255, green: 255 / 255,
                                                blue: 255 / 255,
                                                opacity: 0.5))
                                )
                        }
                        HStack(spacing: 24) {
                            VStack {
                                Text("666")
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                Text("关注")
                                    .font(.footnote)
                                    .foregroundColor(.black)
                            }
                            VStack {
                                Text("666")
                                    .font(.footnote)
                                    .foregroundColor(.black)
                                Text("粉丝")
                                    .font(.footnote)
                                    .foregroundColor(.black)
                            }
                        }
                    }

                }.padding()
                HStack {
                    Text(
                        "点关注点关注点关点点关注点关注点关点点关注点关注点关点点关注点关。"
                    )
                    Spacer()
                }.padding(.horizontal, 16)
                // Tab buttons
                HStack(spacing: 0) {

                    Button(action: {
                        selectedTab = 0
                    }) {
                        VStack(spacing: 8) {
                            Text("发布")
                                .foregroundColor(selectedTab == 0 ? .black : .gray)
                                .fontWeight(selectedTab == 0 ? .semibold : .regular)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)

                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Button(action: {
                        selectedTab = 1
                    }) {
                        VStack(spacing: 8) {
                            Text("关注")
                                .foregroundColor(selectedTab == 1 ? .black : .gray)
                                .fontWeight(selectedTab == 1 ? .semibold : .regular)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)

                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Button(action: {
                        selectedTab = 2
                        selectedCardTab = "成长历程"
                    }) {
                        VStack(spacing: 8) {
                            Text("卡牌")
                                .foregroundColor(selectedTab == 2 ? .black : .gray)
                                .fontWeight(selectedTab == 2 ? .semibold : .regular)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)

                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Button(action: {
                        onShowGoalView?()
                        print("show goal view")
                    }) {
                        VStack(spacing: 8) {
                            Text("足迹")
                                .foregroundColor(.gray)
                                .fontWeight(.regular)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)

                        }
                    }
                    .buttonStyle(PlainButtonStyle())

                }
                .padding(.vertical)

                // Tab content
                VStack {
                    switch selectedTab {
                    case 0:
                        ScrollView {
                            LazyVStack(spacing: 40) {
                                ForEach(0..<6) { index in
                                    VStack(spacing: 12) {
                                        HStack(spacing: 16) {
                                            Image("prof-pic")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 48, height: 48)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                            Text("Tanya")
                                                .font(.title2)
                                                .foregroundColor(.black)
                                            Spacer()
                                            Text("5分钟前")
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }
                                        Text(
                                            "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX."
                                        )
                                        .font(.body)
                                        .foregroundColor(.black)
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            LazyHStack(spacing: 12) {
                                                ForEach(0..<6) { index in
                                                    Image("post-placeholder")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 200, height: 200)
                                                        .clipShape(
                                                            RoundedRectangle(cornerRadius: 10))
                                                }
                                            }
                                        }
                                        HStack(spacing: 16) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "mappin")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 12, height: 12)
                                                    .foregroundColor(.black)
                                                Text("河北省, 秦皇岛市")
                                                    .font(.caption)
                                                    .foregroundColor(.black)
                                            }
                                            Spacer()
                                            Image(systemName: "heart")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.black)
                                            Image(systemName: "star")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.black)
                                            Image(systemName: "message")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.black)

                                        }

                                    }.frame(
                                        maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    case 1:
                        ScrollView {
                            LazyVStack(spacing: 15) {
                                ForEach(0..<6) { index in
                                    HStack(spacing: 16) {
                                        Image("prof-pic")
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 62, height: 62)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("徐志胜")
                                                .font(.title2)
                                                .foregroundColor(.black)
                                            HStack(spacing: 4) {
                                                Image(systemName: "mappin")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 12, height: 12)
                                                    .foregroundColor(.black)
                                                Text("河北省, 秦皇岛市")
                                                    .font(.caption)
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    }.padding().frame(maxWidth: .infinity, alignment: .leading)
                                        .background(
                                            Color(
                                                red: 255 / 255, green: 255 / 255,
                                                blue: 255 / 255,
                                                opacity: 0.5)
                                        )
                                        .cornerRadius(10)
                                }
                            }
                        }
                    case 2:
                        let cardTabs = ["成长历程", "步履不停", "足迹时光", "装备收集"]
                        VStack {
                            LazyVGrid(
                                columns: [
                                    GridItem(.flexible(), spacing: 8),
                                    GridItem(.flexible(), spacing: 8),
                                    GridItem(.flexible(), spacing: 8),

                                ],
                                spacing: 16
                            ) {
                                ForEach(0..<cardTabs.count) { index in
                                    Button(action: {
                                        selectedCardTab = cardTabs[index]
                                    }) {
                                        VStack(spacing: 8) {
                                            Text(cardTabs[index])
                                                .font(.subheadline)
                                                .foregroundColor(
                                                    selectedCardTab == cardTabs[index]
                                                        ? .black : .gray
                                                )
                                                .fontWeight(
                                                    selectedCardTab == cardTabs[index]
                                                        ? .semibold : .regular
                                                )
                                                .frame(maxWidth: .infinity)

                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())

                                }
                            }.padding(.vertical, 16)
                            ScrollViewReader { proxy in
                                ScrollView {
                                    LazyVStack(spacing: 8) {
                                        VStack(spacing: 8) {
                                            Text("成长历程")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                            Text("每一天都有迹可循")
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }
                                        .id("成长历程")
                                        LazyVGrid(
                                            columns: [
                                                GridItem(.flexible(), spacing: 8),
                                                GridItem(.flexible(), spacing: 8),
                                                GridItem(.flexible(), spacing: 8),

                                            ],
                                            spacing: 16
                                        ) {

                                            Button(action: {

                                            }) {
                                                VStack(spacing: 8) {
                                                    Image("sticker-1")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(
                                                            RoundedRectangle(cornerRadius: 10))
                                                    Text("用户注册时间7天")
                                                        .font(.caption)
                                                        .foregroundColor(.black)
                                                        .multilineTextAlignment(.center)

                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            Button(action: {

                                            }) {
                                                VStack(spacing: 8) {
                                                    Image("sticker-2")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(
                                                            RoundedRectangle(cornerRadius: 10))
                                                    Text("用户注册时间1个月")
                                                        .font(.caption)
                                                        .foregroundColor(.black)
                                                        .multilineTextAlignment(.center)

                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            Button(action: {

                                            }) {
                                                VStack(spacing: 8) {
                                                    Image("sticker-3")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(
                                                            RoundedRectangle(cornerRadius: 10))
                                                    Text("用户充值100元")
                                                        .font(.caption)
                                                        .foregroundColor(.black)
                                                        .multilineTextAlignment(.center)

                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())

                                        }.padding(.vertical, 16)
                                        VStack(spacing: 8) {
                                            Text("步履不停")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                            Text("每一天都有迹可循")
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }
                                        .id("步履不停")
                                        LazyVGrid(
                                            columns: [
                                                GridItem(.flexible(), spacing: 8),
                                                GridItem(.flexible(), spacing: 8),
                                                GridItem(.flexible(), spacing: 8),

                                            ],
                                            spacing: 16
                                        ) {

                                            Button(action: {

                                            }) {
                                                VStack(spacing: 8) {
                                                    Image("sticker-1")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(
                                                            RoundedRectangle(cornerRadius: 10))
                                                    Text("用户注册时间7天")
                                                        .font(.caption)
                                                        .foregroundColor(.black)
                                                        .multilineTextAlignment(.center)

                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            Button(action: {

                                            }) {
                                                VStack(spacing: 8) {
                                                    Image("sticker-2")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(
                                                            RoundedRectangle(cornerRadius: 10))
                                                    Text("用户注册时间1个月")
                                                        .font(.caption)
                                                        .foregroundColor(.black)
                                                        .multilineTextAlignment(.center)

                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            Button(action: {

                                            }) {
                                                VStack(spacing: 8) {
                                                    Image("sticker-3")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(
                                                            RoundedRectangle(cornerRadius: 10))
                                                    Text("用户充值100元")
                                                        .font(.caption)
                                                        .foregroundColor(.black)
                                                        .multilineTextAlignment(.center)

                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())

                                        }.padding(.vertical, 16)
                                        VStack(spacing: 8) {
                                            Text("足迹时光")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                            Text("每一天都有迹可循")
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }
                                        .id("足迹时光")
                                        LazyVGrid(
                                            columns: [
                                                GridItem(.flexible(), spacing: 8),
                                                GridItem(.flexible(), spacing: 8),
                                                GridItem(.flexible(), spacing: 8),

                                            ],
                                            spacing: 16
                                        ) {

                                            Button(action: {

                                            }) {
                                                VStack(spacing: 8) {
                                                    Image("sticker-1")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(
                                                            RoundedRectangle(cornerRadius: 10))
                                                    Text("足迹记录")
                                                        .font(.caption)
                                                        .foregroundColor(.black)
                                                        .multilineTextAlignment(.center)

                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            Button(action: {

                                            }) {
                                                VStack(spacing: 8) {
                                                    Image("sticker-2")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(
                                                            RoundedRectangle(cornerRadius: 10))
                                                    Text("时光相册")
                                                        .font(.caption)
                                                        .foregroundColor(.black)
                                                        .multilineTextAlignment(.center)

                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            Button(action: {

                                            }) {
                                                VStack(spacing: 8) {
                                                    Image("sticker-3")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(
                                                            RoundedRectangle(cornerRadius: 10))
                                                    Text("回忆录")
                                                        .font(.caption)
                                                        .foregroundColor(.black)
                                                        .multilineTextAlignment(.center)

                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())

                                        }.padding(.vertical, 16)
                                        VStack(spacing: 8) {
                                            Text("装备收集")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.black)
                                            Text("每一天都有迹可循")
                                                .font(.caption)
                                                .foregroundColor(.black)
                                        }
                                        .id("装备收集")
                                        LazyVGrid(
                                            columns: [
                                                GridItem(.flexible(), spacing: 8),
                                                GridItem(.flexible(), spacing: 8),
                                                GridItem(.flexible(), spacing: 8),

                                            ],
                                            spacing: 16
                                        ) {

                                            Button(action: {

                                            }) {
                                                VStack(spacing: 8) {
                                                    Image("sticker-1")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(
                                                            RoundedRectangle(cornerRadius: 10))
                                                    Text("背包装备")
                                                        .font(.caption)
                                                        .foregroundColor(.black)
                                                        .multilineTextAlignment(.center)

                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            Button(action: {

                                            }) {
                                                VStack(spacing: 8) {
                                                    Image("sticker-2")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(
                                                            RoundedRectangle(cornerRadius: 10))
                                                    Text("相机收藏")
                                                        .font(.caption)
                                                        .foregroundColor(.black)
                                                        .multilineTextAlignment(.center)

                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                            Button(action: {

                                            }) {
                                                VStack(spacing: 8) {
                                                    Image("sticker-3")
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 100, height: 100)
                                                        .clipShape(
                                                            RoundedRectangle(cornerRadius: 10))
                                                    Text("工具箱")
                                                        .font(.caption)
                                                        .foregroundColor(.black)
                                                        .multilineTextAlignment(.center)

                                                }
                                            }
                                            .buttonStyle(PlainButtonStyle())

                                        }.padding(.vertical, 16)
                                    }
                                }
                                .onChange(of: selectedCardTab) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        proxy.scrollTo(selectedCardTab, anchor: .top)
                                    }
                                }
                            }
                        }.padding().background(
                            Color(
                                red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.5)
                        ).cornerRadius(10)
                    default:
                        Text("个人简介")
                            .font(.body)
                            .padding()
                    }

                }
                .padding(.horizontal, 16)

                Spacer()
            }.padding().padding(.bottom, 80)
        }
    }
}

#Preview {
    ProfileView(onShowGoalView: nil, onLogout: {}, onShowSettings: nil, onShowMessages: nil)
}

// Active tab indicator
/* Rectangle()
    .fill(selectedTab == index ? Color.black : Color.clear)
    .frame(height: 2)
    .animation(.easeInOut(duration: 0.2), value: selectedTab) */
