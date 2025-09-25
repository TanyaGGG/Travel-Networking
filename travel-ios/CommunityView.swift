import SwiftUI

struct PodiumView: View {
    let firstPlace: LeaderboardUser
    let secondPlace: LeaderboardUser
    let thirdPlace: LeaderboardUser
    let isDistanceLeaderboard: Bool  // true for distance, false for cards
    let onUserTap: (LeaderboardUser) -> Void

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            // Second Place
            Button(action: {
                onUserTap(secondPlace)
            }) {
                VStack(spacing: 8) {
                    // Crown/Medal
                    /* Image(systemName: "medal.fill")
                        .font(.title)
                        .foregroundColor(.gray) */

                    // Profile Image
                    Image("prof-pic")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.gray, lineWidth: 2)
                        )

                    // Name
                    Text(secondPlace.name)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .lineLimit(1)

                    // Score
                    VStack(spacing: 2) {
                        Text("\(secondPlace.score)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text(isDistanceLeaderboard ? "km" : "张")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }

                    // Podium Base
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [Color.gray.opacity(0.8), Color.gray.opacity(0.6)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 100, height: 60)
                        .overlay(
                            Text("2")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                }
            }
            .buttonStyle(PlainButtonStyle())

            // First Place
            Button(action: {
                onUserTap(firstPlace)
            }) {
                VStack(spacing: 8) {
                    // Crown/Medal
                    /* Image(systemName: "crown.fill")
                        .font(.title)
                        .foregroundColor(.yellow) */

                    // Profile Image
                    Image("prof-pic")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.yellow, lineWidth: 3)
                        )

                    // Name
                    Text(firstPlace.name)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .lineLimit(1)

                    // Score
                    VStack(spacing: 2) {
                        Text("\(firstPlace.score)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text(isDistanceLeaderboard ? "km" : "张")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    // Podium Base
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [Color.yellow.opacity(0.8), Color.orange.opacity(0.6)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 110, height: 80)
                        .overlay(
                            Text("1")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                }
            }
            .buttonStyle(PlainButtonStyle())

            // Third Place
            Button(action: {
                onUserTap(thirdPlace)
            }) {
                VStack(spacing: 8) {
                    // Crown/Medal
                    /* Image(systemName: "medal.fill")
                        .font(.title)
                        .foregroundColor(.brown) */

                    // Profile Image
                    Image("prof-pic")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.brown, lineWidth: 2)
                        )

                    // Name
                    Text(thirdPlace.name)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .lineLimit(1)

                    // Score
                    VStack(spacing: 2) {
                        Text("\(thirdPlace.score)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)
                        Text(isDistanceLeaderboard ? "km" : "张")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }

                    // Podium Base
                    RoundedRectangle(cornerRadius: 8)
                        .fill(
                            LinearGradient(
                                colors: [Color.brown.opacity(0.8), Color.brown.opacity(0.6)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 95, height: 50)
                        .overlay(
                            Text("3")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        )
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
        /* .padding()
        .background(
            Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.7)
        )
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2) */
    }
}

struct LeaderboardUser: Hashable {
    let id: String
    let name: String
    let score: Int
    let location: String
}

struct CommunityView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var selectedTab: Int = 0

    // Sub-tab states for 里程榜 and 卡牌榜
    @State private var lichengSubTab: Int = 0  // 0 for 朋友榜, 1 for 总榜
    @State private var kapaiSubTab: Int = 0  // 0 for 朋友榜, 1 for 总榜

    // Popup callback passed from MainTabView
    let onPopupShow: (PopupType) -> Void

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

                // Tab buttons at the top
                HStack(spacing: 0) {
                    Button(action: {
                        selectedTab = 0
                    }) {
                        VStack(spacing: 8) {
                            Text("关注")
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
                            Text("推荐")
                                .foregroundColor(selectedTab == 1 ? .black : .gray)
                                .fontWeight(selectedTab == 1 ? .semibold : .regular)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        selectedTab = 2
                    }) {
                        VStack(spacing: 8) {
                            Text("里程榜")
                                .foregroundColor(selectedTab == 2 ? .black : .gray)
                                .fontWeight(selectedTab == 2 ? .semibold : .regular)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        selectedTab = 3
                    }) {
                        VStack(spacing: 8) {
                            Text("卡牌榜")
                                .foregroundColor(selectedTab == 3 ? .black : .gray)
                                .fontWeight(selectedTab == 3 ? .semibold : .regular)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 8)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Button(action: {
                        onPopupShow(.search)
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: "magnifyingglass")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 18, height: 18)
                                .foregroundColor(.black)
                        }.frame(maxWidth: .infinity)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)

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
                        }.padding(.horizontal, 32)
                            .padding(.vertical, 16)
                    /* ScrollView {
                        LazyVStack(spacing: 20) {
                            ForEach(0..<5) { index in
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack(spacing: 12) {
                                        Circle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 40, height: 40)
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text("用户 \(index + 1)")
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            Text("2小时前")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                    }
                    
                                    Text("这是推荐内容的占位文本。用户可以在这里分享他们的旅行经历和照片。")
                                        .font(.body)
                                        .foregroundColor(.black)
                    
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 200)
                                        .cornerRadius(10)
                    
                                    HStack {
                                        Image(systemName: "heart")
                                            .foregroundColor(.black)
                                        Text("123")
                                            .font(.caption)
                                            .foregroundColor(.black)
                    
                                        Image(systemName: "message")
                                            .foregroundColor(.black)
                                        Text("45")
                                            .font(.caption)
                                            .foregroundColor(.black)
                    
                                        Spacer()
                    
                                        Image(systemName: "mappin")
                                            .foregroundColor(.black)
                                        Text("北京市")
                                            .font(.caption)
                                            .foregroundColor(.black)
                                    }
                                }
                                .padding()
                                .background(
                                    Color(
                                        red: 255 / 255, green: 255 / 255, blue: 255 / 255,
                                        opacity: 0.5)
                                )
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal, 16)
                    } */

                    case 1:
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
                        }.padding(.horizontal, 32)
                            .padding(.vertical, 16)
                    /* ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(0..<3) { index in
                                HStack(spacing: 16) {
                                    Circle()
                                        .fill(Color.blue.opacity(0.3))
                                        .frame(width: 50, height: 50)
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("关注的用户 \(index + 1)")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                        Text("刚刚发布了新的旅行动态")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    Color(
                                        red: 255 / 255, green: 255 / 255, blue: 255 / 255,
                                        opacity: 0.5)
                                )
                                .cornerRadius(10)
                            }
                        }
                        .padding(.horizontal, 16)
                    } */

                    case 2:
                        VStack(spacing: 8) {
                            // Sub-tabs for 里程榜

                            // Content for selected sub-tab
                            ScrollView {
                                LazyVStack(spacing: 20) {
                                    // Podium for top 3
                                    PodiumView(
                                        firstPlace: LeaderboardUser(
                                            id: "user1",
                                            name: lichengSubTab == 0 ? "朋友 1" : "用户 1",
                                            score: 10000,
                                            location: "河北省, 秦皇岛市"
                                        ),
                                        secondPlace: LeaderboardUser(
                                            id: "user2",
                                            name: lichengSubTab == 0 ? "朋友 2" : "用户 2",
                                            score: 9000,
                                            location: "河北省, 秦皇岛市"
                                        ),
                                        thirdPlace: LeaderboardUser(
                                            id: "user3",
                                            name: lichengSubTab == 0 ? "朋友 3" : "用户 3",
                                            score: 8000,
                                            location: "河北省, 秦皇岛市"
                                        ),
                                        isDistanceLeaderboard: true,
                                        onUserTap: { user in
                                            coordinator.pushMain(
                                                .userProfile(userId: user.id, userName: user.name))
                                        }
                                    )
                                    .padding(.top, 10)

                                    // Remaining rankings (4th place onwards)
                                    ForEach(3..<10) { index in
                                        Button(action: {
                                            let user = LeaderboardUser(
                                                id: "user\(index + 1)",
                                                name: lichengSubTab == 0
                                                    ? "朋友 \(index + 1)" : "用户 \(index + 1)",
                                                score: (10 - index) * 1000,
                                                location: "河北省, 秦皇岛市"
                                            )
                                            coordinator.pushMain(
                                                .userProfile(userId: user.id, userName: user.name))
                                        }) {
                                            HStack(spacing: 16) {
                                                // Ranking number
                                                Text("\(index + 1)")
                                                    .font(.title2)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.black)
                                                    .frame(width: 30)

                                                // Profile picture
                                                Image("prof-pic")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 50, height: 50)
                                                    .clipShape(
                                                        RoundedRectangle(cornerRadius: 10))

                                                // User info
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(
                                                        lichengSubTab == 0
                                                            ? "朋友 \(index + 1)"
                                                            : "用户 \(index + 1)"
                                                    )
                                                    .font(.headline)
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

                                                Spacer()

                                                // Mileage
                                                VStack(alignment: .trailing, spacing: 4) {
                                                    Text("\((10 - index) * 1000)")
                                                        .font(.title3)
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(.black)
                                                    Text("km")
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            .padding()
                                            .background(
                                                Color(
                                                    red: 255 / 255, green: 255 / 255,
                                                    blue: 255 / 255,
                                                    opacity: 0.5)
                                            )
                                            .cornerRadius(10)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }

                            }
                            HStack(spacing: 0) {
                                Button(action: {
                                    lichengSubTab = 0
                                }) {
                                    VStack(spacing: 8) {
                                        Text("朋友榜")
                                            .foregroundColor(.white)
                                            .fontWeight(
                                                lichengSubTab == 0 ? .semibold : .regular
                                            )
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(
                                                lichengSubTab == 0
                                                    ? Color(
                                                        red: 181 / 255, green: 216 / 255,
                                                        blue: 130 / 255)
                                                    : Color(
                                                        red: 255 / 255, green: 255 / 255,
                                                        blue: 255 / 255, opacity: 0.5))
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .cornerRadius(10, corners: [.topLeft, .bottomLeft])

                                Button(action: {
                                    lichengSubTab = 1
                                }) {
                                    VStack(spacing: 8) {
                                        Text("总榜")
                                            .foregroundColor(.white)
                                            .fontWeight(
                                                lichengSubTab == 1 ? .semibold : .regular
                                            )
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(
                                                lichengSubTab == 1
                                                    ? Color(
                                                        red: 181 / 255, green: 216 / 255,
                                                        blue: 130 / 255)
                                                    : Color(
                                                        red: 255 / 255, green: 255 / 255,
                                                        blue: 255 / 255, opacity: 0.5))
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .cornerRadius(10, corners: [.topRight, .bottomRight])
                            }

                            .padding(.vertical, 8)
                        }.padding(.horizontal, 32)
                            .padding(.vertical, 16)

                    case 3:
                        VStack(spacing: 8) {

                            // Content for selected sub-tab
                            ScrollView {
                                LazyVStack(spacing: 20) {
                                    // Podium for top 3
                                    PodiumView(
                                        firstPlace: LeaderboardUser(
                                            id: "user1",
                                            name: kapaiSubTab == 0 ? "朋友 1" : "用户 1",
                                            score: 50,
                                            location: "河北省, 秦皇岛市"
                                        ),
                                        secondPlace: LeaderboardUser(
                                            id: "user2",
                                            name: kapaiSubTab == 0 ? "朋友 2" : "用户 2",
                                            score: 45,
                                            location: "河北省, 秦皇岛市"
                                        ),
                                        thirdPlace: LeaderboardUser(
                                            id: "user3",
                                            name: kapaiSubTab == 0 ? "朋友 3" : "用户 3",
                                            score: 40,
                                            location: "河北省, 秦皇岛市"
                                        ),
                                        isDistanceLeaderboard: false,
                                        onUserTap: { user in
                                            coordinator.pushMain(
                                                .userProfile(userId: user.id, userName: user.name))
                                        }
                                    )
                                    .padding(.top, 10)

                                    // Remaining rankings (4th place onwards)
                                    ForEach(3..<10) { index in
                                        Button(action: {
                                            let user = LeaderboardUser(
                                                id: "user\(index + 1)",
                                                name: kapaiSubTab == 0
                                                    ? "朋友 \(index + 1)" : "用户 \(index + 1)",
                                                score: (10 - index) * 5,
                                                location: "河北省, 秦皇岛市"
                                            )
                                            coordinator.pushMain(
                                                .userProfile(userId: user.id, userName: user.name))
                                        }) {
                                            HStack(spacing: 16) {
                                                // Ranking number
                                                Text("\(index + 1)")
                                                    .font(.title2)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.black)
                                                    .frame(width: 30)

                                                // Profile picture
                                                Image("prof-pic")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 50, height: 50)
                                                    .clipShape(
                                                        RoundedRectangle(cornerRadius: 10))

                                                // User info
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(
                                                        kapaiSubTab == 0
                                                            ? "朋友 \(index + 1)"
                                                            : "用户 \(index + 1)"
                                                    )
                                                    .font(.headline)
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

                                                Spacer()

                                                // Cards count
                                                VStack(alignment: .trailing, spacing: 4) {
                                                    Text("\((10 - index) * 5)")
                                                        .font(.title3)
                                                        .fontWeight(.semibold)
                                                        .foregroundColor(.black)
                                                    Text("张")
                                                        .font(.caption)
                                                        .foregroundColor(.gray)
                                                }
                                            }
                                            .padding()
                                            .background(
                                                Color(
                                                    red: 255 / 255, green: 255 / 255,
                                                    blue: 255 / 255,
                                                    opacity: 0.5)
                                            )
                                            .cornerRadius(10)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }

                            }
                            HStack(spacing: 0) {
                                Button(action: {
                                    kapaiSubTab = 0
                                }) {
                                    VStack(spacing: 8) {
                                        Text("朋友榜")
                                            .foregroundColor(.white)
                                            .fontWeight(kapaiSubTab == 0 ? .semibold : .regular)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(
                                                kapaiSubTab == 0
                                                    ? Color(
                                                        red: 181 / 255, green: 216 / 255,
                                                        blue: 130 / 255)
                                                    : Color(
                                                        red: 255 / 255, green: 255 / 255,
                                                        blue: 255 / 255, opacity: 0.5))
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .cornerRadius(10, corners: [.topLeft, .bottomLeft])

                                Button(action: {
                                    kapaiSubTab = 1
                                }) {
                                    VStack(spacing: 8) {
                                        Text("总榜")
                                            .foregroundColor(.white)
                                            .fontWeight(kapaiSubTab == 1 ? .semibold : .regular)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(
                                                kapaiSubTab == 1
                                                    ? Color(
                                                        red: 181 / 255, green: 216 / 255,
                                                        blue: 130 / 255)
                                                    : Color(
                                                        red: 255 / 255, green: 255 / 255,
                                                        blue: 255 / 255, opacity: 0.5))
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .cornerRadius(10, corners: [.topRight, .bottomRight])
                            }

                            .padding(.vertical, 8)
                        }.padding(.horizontal, 32)
                            .padding(.vertical, 16)

                    default:
                        Text("默认内容")
                            .font(.body)
                            .padding()
                    }
                }
                .padding(.top, 16)

                Spacer()
            }
            .padding(.bottom, 80)
        }
    }
}

#Preview {
    CommunityView(
        onPopupShow: { _ in }
    )
}
