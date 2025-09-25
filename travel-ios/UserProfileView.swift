import SwiftUI

struct CardTabButtonsView: View {
    @Binding var selectedCardTab: String
    let cardTabs = ["成长历程", "步履不停", "足迹时光", "装备收集"]

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8),
                GridItem(.flexible(), spacing: 8),
            ],
            spacing: 16
        ) {
            ForEach(0..<4) { index in
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
        }
        .padding(.vertical, 16)
    }
}

struct StickerItemView: View {
    let imageName: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text(title)
                    .font(.caption)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CardSectionView: View {
    let title: String
    let subtitle: String
    let stickers: [(imageName: String, title: String)]

    var body: some View {
        VStack(spacing: 8) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.black)
            }

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8),
                ],
                spacing: 16
            ) {
                ForEach(Array(stickers.enumerated()), id: \.offset) { index, sticker in
                    StickerItemView(
                        imageName: sticker.imageName,
                        title: sticker.title
                    ) {
                        // Action for sticker tap
                    }
                }
            }
            .padding(.vertical, 16)
        }
    }
}

struct UserProfileView: View {
    let userId: String
    let userName: String
    @EnvironmentObject var coordinator: AppCoordinator
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

            VStack(spacing: 0) {

                VStack {

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
                                Text(userName)
                                    .font(.title)

                            }
                            HStack(alignment: .top) {
                                Text("UID: 123456789")
                                    .font(.caption)

                            }
                        }

                        Spacer()
                        VStack {
                            Button(action: {
                                // TODO: Add logout action
                            }) {
                                Text("关注")
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
                            VStack {
                                CardTabButtonsView(selectedCardTab: $selectedCardTab)

                                ScrollViewReader { proxy in
                                    ScrollView {
                                        LazyVStack(spacing: 8) {
                                            CardSectionView(
                                                title: "成长历程",
                                                subtitle: "每一天都有迹可循",
                                                stickers: [
                                                    ("sticker-1", "用户注册时间7天"),
                                                    ("sticker-2", "用户注册时间1个月"),
                                                    ("sticker-3", "用户充值100元"),
                                                ]
                                            )
                                            .id("成长历程")

                                            CardSectionView(
                                                title: "步履不停",
                                                subtitle: "每一天都有迹可循",
                                                stickers: [
                                                    ("sticker-1", "用户注册时间7天"),
                                                    ("sticker-2", "用户注册时间1个月"),
                                                    ("sticker-3", "用户充值100元"),
                                                ]
                                            )
                                            .id("步履不停")

                                            CardSectionView(
                                                title: "足迹时光",
                                                subtitle: "每一天都有迹可循",
                                                stickers: [
                                                    ("sticker-1", "足迹记录"),
                                                    ("sticker-2", "时光相册"),
                                                    ("sticker-3", "回忆录"),
                                                ]
                                            )
                                            .id("足迹时光")

                                            CardSectionView(
                                                title: "装备收集",
                                                subtitle: "每一天都有迹可循",
                                                stickers: [
                                                    ("sticker-1", "背包装备"),
                                                    ("sticker-2", "相机收藏"),
                                                    ("sticker-3", "工具箱"),
                                                ]
                                            )
                                            .id("装备收集")
                                        }
                                    }
                                    .onChange(of: selectedCardTab) { _, newValue in
                                        withAnimation(.easeInOut(duration: 0.5)) {
                                            proxy.scrollTo(newValue, anchor: .top)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(
                                Color(
                                    red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.5)
                            )
                            .cornerRadius(10)
                        default:
                            Text("个人简介")
                                .font(.body)
                                .padding()
                        }

                    }
                    .padding(.horizontal, 16)

                    Spacer()
                }.padding()

                /* ScrollView {
                    VStack(spacing: 24) {
                        // Profile Header
                        VStack(spacing: 16) {
                            // Profile Image
                            Image("prof-pic")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 4)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                
                            // User Info
                            VStack(spacing: 8) {
                                Text(userName)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                
                                HStack(spacing: 4) {
                                    Image(systemName: "mappin")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 16, height: 16)
                                        .foregroundColor(.black)
                                    Text("河北省, 秦皇岛市")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding(.top, 20)
                
                        // Stats Section
                        HStack(spacing: 20) {
                            VStack(spacing: 8) {
                                Text("12,580")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                Text("总里程")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                Color(
                                    red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.7)
                            )
                            .cornerRadius(12)
                
                            VStack(spacing: 8) {
                                Text("47")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                Text("收集卡牌")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                Color(
                                    red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.7)
                            )
                            .cornerRadius(12)
                
                            VStack(spacing: 8) {
                                Text("23")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                Text("访问城市")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                Color(
                                    red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.7)
                            )
                            .cornerRadius(12)
                        }
                        .padding(.horizontal, 16)
                
                        // Recent Activities Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("最近动态")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                
                            LazyVStack(spacing: 16) {
                                ForEach(0..<3) { index in
                                    VStack(spacing: 12) {
                                        HStack(spacing: 12) {
                                            Image("prof-pic")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(userName)
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.black)
                                                Text("\(index + 1)天前")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                
                                            Spacer()
                                        }
                
                                        Text("刚刚完成了一次精彩的旅行，收集了新的城市卡牌！这次旅程让我对这个地方有了全新的认识。")
                                            .font(.body)
                                            .foregroundColor(.black)
                                            .multilineTextAlignment(.leading)
                
                                        // Sample travel image
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(height: 200)
                                            .cornerRadius(12)
                                            .overlay(
                                                Text("旅行照片")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            )
                
                                        HStack(spacing: 16) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "mappin")
                                                    .font(.caption)
                                                    .foregroundColor(.black)
                                                Text("河北省, 秦皇岛市")
                                                    .font(.caption)
                                                    .foregroundColor(.black)
                                            }
                
                                            Spacer()
                
                                            HStack(spacing: 16) {
                                                Image(systemName: "heart")
                                                    .font(.system(size: 18))
                                                    .foregroundColor(.black)
                
                                                Image(systemName: "message")
                                                    .font(.system(size: 18))
                                                    .foregroundColor(.black)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(
                                        Color(
                                            red: 255 / 255, green: 255 / 255, blue: 255 / 255,
                                            opacity: 0.7)
                                    )
                                    .cornerRadius(12)
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                
                        // Travel Map Section (placeholder)
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("旅行足迹")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 200)
                                .cornerRadius(12)
                                .overlay(
                                    VStack(spacing: 8) {
                                        Image(systemName: "map")
                                            .font(.largeTitle)
                                            .foregroundColor(.gray)
                                        Text("旅行地图")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                )
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .padding(.top, 16) */
            }
        }
        .navigationBarBackButtonHidden(true).toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    coordinator.popMain()
                }) {
                    Image(systemName: "chevron.left").foregroundColor(.black)
                }
            }
        }
    }

}

#Preview {
    UserProfileView(userId: "user123", userName: "示例用户")
}
