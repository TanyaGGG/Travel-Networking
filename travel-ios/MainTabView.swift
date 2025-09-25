import SwiftUI
import UIKit

extension Color {
    static let customWhiteOverlay = Color(
        red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.5)
    static let customGrayBorder = Color(red: 69 / 255, green: 59 / 255, blue: 69 / 255, opacity: 1)
    static let customYellow = Color(red: 205 / 255, green: 217 / 255, blue: 122 / 255, opacity: 1)
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// Individual popup content views
/* struct BasketPopupView: View {
    let onClose: () -> Void

    let basketItems = [
        ("旅行必需品", ["护照", "钱包", "手机充电器", "药品"], "📋"),
        ("衣物用品", ["T恤 x3", "牛仔裤 x2", "内衣裤", "袜子"], "👕"),
        ("电子设备", ["笔记本电脑", "相机", "耳机", "充电宝"], "💻"),
        ("洗漱用品", ["牙刷", "牙膏", "洗发水", "护肤品"], "🧴"),
        ("零食饮品", ["巧克力", "坚果", "茶叶", "咖啡"], "🍫"),
        ("其他物品", ["雨伞", "太阳镜", "帽子", "小背包"], "🎒")
    ]

    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 15) {
                HStack {
                    Image(systemName: "basket.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.blue)

                    Text("我的篮子")
                        .font(.title)
                        .fontWeight(.bold)

                    Spacer()

                    Button(action: onClose) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.gray)
                    }
                }

                HStack {
                    VStack(alignment: .leading) {
                        Text("总计物品")
                        Text("24 件")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text("预估重量")
                        Text("8.5 kg")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(15)
            }
            .padding()
            .background(Color.white)

            // Scrollable containers
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(Array(basketItems.enumerated()), id: \.offset) { index, item in
                        BasketContainerView(
                            emoji: item.2,
                            title: item.0,
                            items: item.1,
                            containerColor: getContainerColor(for: index)
                        )
                    }
                }
                .padding()
            }

            // Bottom action bar
            HStack(spacing: 15) {
                Button("整理篮子") {
                    // Action for organizing basket
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.2))
                .foregroundColor(.blue)
                .cornerRadius(10)

                Button("开始打包") {
                    onClose()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding()
            .background(Color.white)
        }
        .background(Color.gray.opacity(0.05))
        .cornerRadius(20)
    }

    private func getContainerColor(for index: Int) -> Color {
        let colors: [Color] = [.blue, .green, .orange, .purple, .pink, .indigo]
        return colors[index % colors.count]
    }
} */

struct CurrencyPopupView: View {
    let onClose: () -> Void
    @State private var isSharePresented = false

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
                        Color.customWhiteOverlay
                            .cornerRadius(10)
                        Image(systemName: "chineseyuanrenminbisign.square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: 40, maxHeight: 40)
                }.padding()
                // Scrollable containers
                ScrollView {
                    LazyVStack(spacing: 15) {
                        /* ForEach(Array(basketItems.enumerated()), id: \.offset) { index, item in
                            BasketContainerView(
                                emoji: item.2,
                                title: item.0,
                                items: item.1,
                                containerColor: getContainerColor(for: index)
                            )
                        } */

                        Image("card-1")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        Color.customGrayBorder,
                                        lineWidth: 3)
                            )
                        Image("card-2")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        Color.customGrayBorder,
                                        lineWidth: 3)
                            )

                        Image("card-3")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        Color.customGrayBorder,
                                        lineWidth: 3)
                            )
                        Image("card-4")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(
                                        Color.customGrayBorder,
                                        lineWidth: 3)
                            )
                            .onTapGesture {
                                isSharePresented = true
                            }

                        // .clipShape(RoundedRectangle(cornerRadius: 10))

                    }.padding()
                }
            }
        }
        .sheet(isPresented: $isSharePresented) {
            ShareSheet(activityItems: ["Check out this travel card from my basket!"])
        }
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheet>)
        -> UIActivityViewController
    {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<ShareSheet>
    ) {}
}

/* struct BasketContainerView: View {
    let emoji: String
    let title: String
    let items: [String]
    let containerColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(emoji)
                    .font(.title2)

                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()

                Text("\(items.count) 件")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(containerColor.opacity(0.3))
                    .cornerRadius(8)
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Circle()
                            .fill(containerColor)
                            .frame(width: 6, height: 6)

                        Text(item)
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(containerColor.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(12)
    }
}
 */
struct LocationSelectionPopupView: View {
    let onClose: () -> Void
    let onLocationSelected: (String) -> Void
    @State private var searchText = ""

    private let hotCities = [
        "北京", "上海", "深圳", "成都", "杭州", "广州", "重庆", "昆明", "三亚", "厦门", "海拉尔", "西安", "长沙", "武汉", "青岛",
        "大连",
    ]

    private let allCities = [
        "A": ["阿克苏", "安庆", "鞍山", "安阳", "阿里"],
        "B": ["北京", "包头", "保定", "北海", "蚌埠", "宝鸡", "本溪", "毕节", "滨州"],
        "C": ["成都", "长春", "重庆", "长沙", "常州", "沧州", "承德", "赤峰", "潮州", "池州"],
        "D": ["大连", "东莞", "大庆", "丹东", "大同", "德州", "东营", "达州", "德阳"],
        "E": ["鄂尔多斯", "恩施", "二连浩特"],
        "F": ["福州", "佛山", "抚顺", "阜阳", "抚州", "防城港"],
        "G": ["广州", "桂林", "贵阳", "赣州", "广元", "贵港", "固原"],
        "H": ["杭州", "海口", "哈尔滨", "合肥", "呼和浩特", "海拉尔", "邯郸", "衡阳", "惠州", "黄山"],
        "J": ["济南", "嘉兴", "江门", "金华", "九江", "吉林", "济宁", "荆州", "锦州", "景德镇"],
        "K": ["昆明", "开封", "喀什"],
        "L": ["兰州", "洛阳", "连云港", "临沂", "柳州", "泸州", "廊坊", "临汾", "六安", "龙岩"],
        "M": ["苏州", "绵阳", "牡丹江", "马鞍山", "茂名", "梅州"],
        "N": ["南京", "宁波", "南宁", "南昌", "南通", "内江", "南阳", "宁德"],
        "P": ["平顶山", "莆田", "攀枝花", "盘锦"],
        "Q": ["青岛", "泉州", "秦皇岛", "齐齐哈尔", "衢州", "清远", "钦州"],
        "R": ["日照", "日喀则"],
        "S": ["上海", "深圳", "沈阳", "石家庄", "苏州", "三亚", "汕头", "绍兴", "十堰", "商丘", "宿迁"],
        "T": ["天津", "太原", "台州", "唐山", "泰安", "通辽", "铁岭", "铜陵", "通化"],
        "W": ["武汉", "无锡", "温州", "乌鲁木齐", "威海", "潍坊", "芜湖", "梧州", "乌海"],
        "X": ["西安", "厦门", "徐州", "西宁", "襄阳", "新乡", "咸阳", "信阳", "许昌", "湘潭"],
        "Y": ["银川", "烟台", "扬州", "宜昌", "岳阳", "运城", "榆林", "玉林", "宜宾", "延安"],
        "Z": ["郑州", "珠海", "中山", "淄博", "舟山", "漳州", "株洲", "湛江", "肇庆", "张家港"],
    ]

    var filteredCities: [String] {
        if searchText.isEmpty {
            return []
        }
        return allCities.values.flatMap { $0 }.filter { city in
            city.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button("取消") {
                    onClose()
                }
                .foregroundColor(.black)

                Spacer()

                Text("选择城市")
                    .font(.headline)
                    .foregroundColor(.black)

                Spacer()

                Text("取消")
                    .foregroundColor(.clear)
            }
            .padding()

            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("搜索城市", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .padding(.horizontal)

            ScrollView {
                if !searchText.isEmpty && !filteredCities.isEmpty {
                    // Search results
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 16
                    ) {
                        ForEach(filteredCities, id: \.self) { city in
                            Button(city) {
                                onLocationSelected(city)
                                onClose()
                            }
                            .foregroundColor(.black)
                            .padding(.vertical, 8)
                        }
                    }
                    .padding()
                } else if searchText.isEmpty {
                    VStack(alignment: .leading, spacing: 20) {
                        // Hot cities section
                        VStack(alignment: .leading, spacing: 12) {
                            Text("热门城市")
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.horizontal)

                            LazyVGrid(
                                columns: Array(repeating: GridItem(.flexible()), count: 4),
                                spacing: 16
                            ) {
                                ForEach(hotCities, id: \.self) { city in
                                    Button(city) {
                                        onLocationSelected(city)
                                        onClose()
                                    }
                                    .foregroundColor(.black)
                                    .padding(.vertical, 8)
                                }
                            }
                            .padding(.horizontal)
                        }

                        // All cities by letter
                        ForEach(allCities.keys.sorted(), id: \.self) { letter in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(letter)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                    .padding(.horizontal)

                                LazyVGrid(
                                    columns: Array(repeating: GridItem(.flexible()), count: 4),
                                    spacing: 16
                                ) {
                                    ForEach(allCities[letter] ?? [], id: \.self) { city in
                                        Button(city) {
                                            onLocationSelected(city)
                                            onClose()
                                        }
                                        .foregroundColor(.black)
                                        .padding(.vertical, 8)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                } else {
                    // No search results
                    VStack {
                        Text("未找到匹配的城市")
                            .foregroundColor(.gray)
                            .padding()
                        Spacer()
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(16)
    }
}

struct SuitcasePopupView: View {
    let onClose: () -> Void
    @State private var selectedFromCity = "哈尔滨"
    @State private var selectedToCity = "三亚"
    @State private var selectedTrain = "G1234"
    @State private var selectedUsers: Set<Int> = []
    @State private var selectedTab: TransportTab = .train
    @State private var showingLocationPicker = false
    @State private var isSelectingFromCity = true
    @State private var selectedTransportType = "飞机"

    enum TransportTab {
        case train
        case otherTransport
    }

    private let companionUsers = [
        ("小明", "user1"),
        ("小红", "user2"),
        ("张伟", "user3"),
        ("李娜", "user4"),
    ]

    private func getTransportIcon(for transportType: String) -> String {
        switch transportType {
        case "飞机":
            return "airplane"
        case "大巴":
            return "bus"
        case "自驾":
            return "bicycle"
        default:
            return "airplane"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header section
            HStack {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .onTapGesture {
                        onClose()
                    }
                Spacer()
                ZStack {
                    Color.customWhiteOverlay
                        .cornerRadius(10)
                    Image(systemName: "suitcase")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: 40, maxHeight: 40)
            }.padding()

            // Transport selection section (fixed at top)
            VStack(spacing: 12) {
                // Tab buttons
                HStack {
                    Button(action: {
                        selectedTab = .train
                    }) {
                        Text("列车")
                            .font(.headline)
                            .foregroundColor(selectedTab == .train ? .black : .gray)
                            .fontWeight(selectedTab == .train ? .semibold : .regular)
                            .frame(maxWidth: .infinity)
                    }

                    Button(action: {
                        selectedTab = .otherTransport
                    }) {
                        Text("其他班车")
                            .font(.headline)
                            .foregroundColor(
                                selectedTab == .otherTransport ? .black : .gray
                            )
                            .fontWeight(
                                selectedTab == .otherTransport ? .semibold : .regular
                            )
                            .frame(maxWidth: .infinity)
                    }
                }

                // Content based on selected tab
                if selectedTab == .train {
                    // Train content
                    VStack(spacing: 12) {
                        // Route selection
                        HStack {
                            Button(action: {
                                isSelectingFromCity = true
                                showingLocationPicker = true
                            }) {
                                VStack {
                                    Text(selectedFromCity)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                }
                            }

                            Spacer()

                            Image(systemName: "arrow.right")
                                .foregroundColor(.gray)

                            Spacer()

                            Button(action: {
                                isSelectingFromCity = false
                                showingLocationPicker = true
                            }) {
                                VStack {
                                    Text(selectedToCity)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)

                        // Train route options
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible()), count: 2),
                            spacing: 8
                        ) {
                            ForEach(["距离", "费用"], id: \.self) { option in
                                Text(option)
                                    .font(.subheadline)
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .background(Color.white.opacity(0.6))
                                    .cornerRadius(8)
                            }
                        }
                    }
                } else {
                    // Other transport content
                    VStack(spacing: 12) {
                        // Route selection for other transport
                        HStack {
                            Button(action: {
                                isSelectingFromCity = true
                                showingLocationPicker = true
                            }) {
                                VStack {
                                    Text(selectedFromCity)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                }
                            }

                            Spacer()

                            Image(systemName: getTransportIcon(for: selectedTransportType))
                                .foregroundColor(.black)

                            Spacer()

                            Button(action: {
                                isSelectingFromCity = false
                                showingLocationPicker = true
                            }) {
                                VStack {
                                    Text(selectedToCity)
                                        .font(.title2)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(12)

                        // Other transport options
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.flexible()), count: 3),
                            spacing: 8
                        ) {
                            ForEach(["飞机", "大巴", "自驾"], id: \.self) { option in
                                Button(action: {
                                    selectedTransportType = option
                                }) {
                                    Text(option)
                                        .font(.subheadline)
                                        .foregroundColor(
                                            selectedTransportType == option ? .white : .black
                                        )
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .background(
                                            selectedTransportType == option
                                                ? Color(
                                                    red: 205 / 255, green: 217 / 255,
                                                    blue: 122 / 255,
                                                    opacity: 1)
                                                : Color.white.opacity(0.6)
                                        )
                                        .cornerRadius(8)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
                HStack {
                    Image("verify-pet")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .foregroundColor(.black)
                    Spacer()
                    Image("login-pet")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.black)
                }
            }
            .padding()
            .background(Color.white.opacity(0.3))
            .cornerRadius(16)
            .padding(.horizontal)
            .padding(.bottom)

            // Bottom card with scrollable content (spans remaining space)
            VStack(spacing: 0) {
                // Fixed header for bottom card
                Text("邀请以下朋友一起出发")
                    .font(.headline)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()

                // Scrollable content area
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(0..<companionUsers.count, id: \.self) { index in
                            Button(action: {
                                if selectedUsers.contains(index) {
                                    selectedUsers.remove(index)
                                } else {
                                    selectedUsers.insert(index)
                                }
                            }) {
                                HStack(spacing: 12) {
                                    // Profile picture on the left
                                    Image("prof-pic")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())

                                    // Name on the left
                                    Text(companionUsers[index].0)
                                        .font(.body)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)

                                    // Checkmark on the right
                                    Image(
                                        systemName: selectedUsers.contains(index)
                                            ? "checkmark.circle.fill" : "circle"
                                    )
                                    .foregroundColor(selectedUsers.contains(index) ? .blue : .gray)
                                    .font(.system(size: 20))
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                //.background(Color.white.opacity(0.6))
                                //.cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Fixed button at bottom
                Button(action: {
                    // Handle send invitation
                }) {
                    Text("确认")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            Color.clear
                        )
                        .cornerRadius(12)
                }
                .padding()
            }
            .background(Color.white.opacity(0.3))
            .cornerRadius(16)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .overlay(
            // Location selection popup overlay
            Group {
                if showingLocationPicker {
                    Color.black.opacity(0)
                        .ignoresSafeArea()
                        .onTapGesture {
                            showingLocationPicker = false
                        }

                    LocationSelectionPopupView(
                        onClose: {
                            showingLocationPicker = false
                        },
                        onLocationSelected: { selectedLocation in
                            if isSelectingFromCity {
                                selectedFromCity = selectedLocation
                            } else {
                                selectedToCity = selectedLocation
                            }
                        }
                    )
                    .padding()
                }
            }
        )
    }
}

struct SearchPopupView: View {
    let onClose: () -> Void
    @State private var searchText: String = ""
    @EnvironmentObject var coordinator: AppCoordinator

    private let sampleUsers = [
        ("小明", "user1"),
        ("小红", "user2"),
        ("张伟", "user3"),
        ("李娜", "user4"),
        ("王强", "user5"),
        ("刘芳", "user6"),
        ("陈杰", "user7"),
        ("赵敏", "user8"),
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
                        Color.customWhiteOverlay
                            .cornerRadius(10)
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: 40, maxHeight: 40)
                }.padding()

                // Search bar
                HStack {
                    TextField("搜索用户、内容...", text: $searchText)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            Color.white.opacity(0.8)
                        )
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, 16)

                // Scrollable search results
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(0..<sampleUsers.count, id: \.self) { index in
                            Button(action: {
                                let user = sampleUsers[index]
                                coordinator.pushMain(.userProfile(userId: user.1, userName: user.0))
                                onClose()
                            }) {
                                HStack(spacing: 12) {
                                    Text("\(index + 1)")
                                        .font(.title)
                                        .foregroundColor(.black)
                                        .padding()
                                    //.background(Color.blue.opacity(0.2))
                                    //.cornerRadius(8)
                                    Image("prof-pic")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(sampleUsers[index].0)
                                            .font(.title3)
                                            .foregroundColor(.black)
                                            .padding(.bottom, 4)
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

                                    /* Button("关注") {
                                        // Follow action
                                    }
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue.opacity(0.2))
                                    .foregroundColor(.blue)
                                    .cornerRadius(8) */
                                }
                                .padding()
                                .background(
                                    Color.white
                                )
                                .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct SettingsPopupView: View {
    let onClose: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0) {

                ScrollView {
                    VStack(spacing: 20) {
                        VStack(spacing: 16) {
                            Text("设置")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.black)

                            VStack(spacing: 12) {
                                SettingsRowView(icon: "person.circle", title: "账户设置", action: {})
                                SettingsRowView(icon: "bell", title: "通知设置", action: {})
                                SettingsRowView(icon: "lock", title: "隐私设置", action: {})
                                SettingsRowView(icon: "paintbrush", title: "主题设置", action: {})
                                SettingsRowView(icon: "globe", title: "语言设置", action: {})
                            }
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct SettingsRowView: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)

                Text(title)
                    .font(.body)
                    .foregroundColor(.black)

                Spacer()

                /* Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray) */
            }
            .padding()

        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct BasketPopupView: View {
    let onClose: () -> Void
    @State private var isSharePresented = false

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
                        Color.customWhiteOverlay
                            .cornerRadius(10)
                        Image(systemName: "basket")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: 40, maxHeight: 40)
                }.padding()
                // Scrollable containers
                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16),
                        ],
                        spacing: 28
                    ) {
                        ForEach(0..<6) { index in
                            if index % 2 == 0 {
                                BasketItemView(imageName: "cat-dino")
                            } else {
                                BasketItemView(imageName: "cat-cart")
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $isSharePresented) {
            ShareSheet(activityItems: ["Check out this travel card from my basket!"])
        }
    }
}

struct BasketItemView: View {
    let imageName: String

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let side = geometry.size.width
                itemContent(side: side)
            }
            .aspectRatio(1, contentMode: .fit)
        }
    }

    private func itemContent(side: CGFloat) -> some View {
        ZStack(alignment: .bottom) {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: side, height: side)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 4)
                )

            Text("1000购买")
                .font(.system(size: 12))
                .foregroundColor(.black)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                )
                .offset(y: side * 0.1)
        }
        .frame(width: side, height: side)
    }
}

struct CustomPopup: View {
    let popupType: PopupType
    let isPresented: Binding<Bool>

    var body: some View {
        ZStack {
            // Background overlay with blur effect
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea(.all)
            /* .onTapGesture {
                isPresented.wrappedValue = false
            } */

            // Popup content - different layout for each type
            Group {
                switch popupType {
                case .basket:
                    BasketPopupView(onClose: {
                        isPresented.wrappedValue = false
                    })
                case .suitcase:
                    SuitcasePopupView(onClose: {
                        isPresented.wrappedValue = false
                    })
                case .currency:
                    CurrencyPopupView(onClose: {
                        isPresented.wrappedValue = false
                    })
                case .settings:
                    SettingsPopupView(onClose: {
                        isPresented.wrappedValue = false
                    })
                case .search:
                    SearchPopupView(onClose: {
                        isPresented.wrappedValue = false
                    })
                case .messages:
                    MessagesPopupView(onClose: {
                        isPresented.wrappedValue = false
                    })
                }
            }
            .background(Color.clear)
            // .cornerRadius(20)
            // .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 5)
            .padding()
        }
    }
}

struct CustomPopupSide: View {
    let popupType: PopupType
    let isPresented: Binding<Bool>
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging: Bool = false
    @EnvironmentObject var coordinator: AppCoordinator

    private let sidebarWidth: CGFloat = UIScreen.main.bounds.width * 0.8
    private let dismissThreshold: CGFloat = 100

    var body: some View {
        ZStack {
            backgroundOverlay
            sidebarContent
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPresented.wrappedValue)
        .onChange(of: isPresented.wrappedValue) { newValue in
            if !newValue {
                dragOffset = 0
            }
        }
    }

    @ViewBuilder
    private var backgroundOverlay: some View {
        if isPresented.wrappedValue {
            Color.customWhiteOverlay
                .ignoresSafeArea(.all)
                .onTapGesture {
                    dismissSidebar()
                }
                .transition(.opacity)
        }
    }

    private var sidebarContent: some View {
        HStack {
            sidebarBody
            Spacer()
        }
    }

    private var sidebarBody: some View {
        VStack(spacing: 0) {
            sidebarHeader
            dynamicContent
        }
        .frame(width: sidebarWidth)
        .frame(maxHeight: .infinity)
        .background(Color.white)
        .offset(x: isPresented.wrappedValue ? dragOffset : -sidebarWidth)
        .gesture(dragGesture)
    }

    private var sidebarHeader: some View {
        HStack {
            Text(getHeaderTitle())
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.black)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
    }

    @ViewBuilder
    private var dynamicContent: some View {
        Group {
            switch popupType {
            case .settings:
                settingsContent
            case .messages:
                messagesContent
            default:
                Spacer()
            }
        }
    }

    private var settingsContent: some View {
        VStack {
            ScrollView {
                VStack(spacing: 8) {
                    SettingsRowView(icon: "person.circle", title: "账户设置", action: {})
                    SettingsRowView(icon: "bell", title: "通知设置", action: {})
                    SettingsRowView(icon: "lock", title: "隐私设置", action: {})
                    SettingsRowView(icon: "paintbrush", title: "主题设置", action: {})
                }
                .padding()
            }
            Spacer()
            logoutButton
        }
    }

    private var logoutButton: some View {
        Button(action: {
            coordinator.logout()
        }) {
            Text("退出登录")
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.customYellow)
                .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }

    private var messagesContent: some View {
        VStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { index in
                        MessageRowView(
                            title: getMessageTitle(for: index),
                            content: getMessageContent(for: index),
                            time: getMessageTime(for: index),
                            type: getMessageType(for: index),
                            isUnread: index < 3
                        )
                    }
                }
                .padding()
            }
            Spacer()
        }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                isDragging = true
                let translation = value.translation.width
                if translation < 0 {
                    dragOffset = max(translation, -sidebarWidth)
                }
            }
            .onEnded { value in
                isDragging = false
                let translation = value.translation.width
                let velocity = value.velocity.width

                if translation < -dismissThreshold || velocity < -500 {
                    dismissSidebar()
                } else {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                        dragOffset = 0
                    }
                }
            }
    }

    private func dismissSidebar() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            isPresented.wrappedValue = false
        }
    }

    private func getHeaderTitle() -> String {
        switch popupType {
        case .settings:
            return "设置"
        case .messages:
            return "消息"
        default:
            return "菜单"
        }
    }

    private func getMessageTitle(for index: Int) -> String {
        let titles = ["赞", "评论", "通知" /*  "张伟", "系统通知", "李娜", "客服", "小明" */]
        return titles[index % titles.count]
    }

    private func getMessageContent(for index: Int) -> String {
        let contents = [
            "点击查看详情",
            "点击查看详情",
            "点击查看详情",
            /* "明天一起去爬山怎么样？",
            "您获得了新的成就徽章",
            "照片拍得很棒！",
            "您的问题已解决，如有其他疑问请联系我们",
            "这个地方我也去过，风景真不错" */
        ]
        return contents[index % contents.count]
    }

    private func getMessageTime(for index: Int) -> String {
        let times = ["1小时前", "2小时前", "3小时前" /* , "5小时前", "1天前", "2天前", "3天前", "1周前" */]
        return times[index % times.count]
    }

    private func getMessageType(for index: Int) -> String {
        let types = [
            "system", "user", "assistant" /* , "user", "system", "user", "support", "user" */,
        ]
        return types[index % types.count]
    }
}

struct MainTabView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var selectedTab = 0

    // Popup state management - single optional state
    @State private var currentPopup: PopupType? = nil

    var body: some View {
        ZStack {
            mainContent
            floatingTabBar
            popupOverlay
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    private var mainContent: some View {
        Group {
            switch selectedTab {
            case 0: HomeView()
            case 1: TreeHouseView(onPopupShow: { currentPopup = $0 })
            case 2:
                CommunityView(onPopupShow: { currentPopup = $0 })
                    .environmentObject(coordinator)
            case 3:
                ProfileView(
                    onShowGoalView: {
                        coordinator.pushMain(.goal)
                    },
                    onLogout: {
                        coordinator.logout()
                    },
                    onShowSettings: {
                        currentPopup = .settings
                    },
                    onShowMessages: {
                        currentPopup = .messages
                    })
            default: HomeView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var floatingTabBar: some View {
        VStack {
            Spacer()
            tabButtons
                .background(tabBarBackground)
        }
        .padding()
    }

    private var tabButtons: some View {
        HStack(spacing: 0) {
            TabButton(
                icon: "duffle.bag.fill",
                title: "旅行",
                isSelected: selectedTab == 0
            ) {
                selectedTab = 0
            }

            TabButton(
                icon: "tree.fill",
                title: "树屋",
                isSelected: selectedTab == 1
            ) {
                selectedTab = 1
            }

            TabButton(
                icon: "person.3.fill",
                title: "社区",
                isSelected: selectedTab == 2
            ) {
                selectedTab = 2
            }

            TabButton(
                icon: "person.circle.fill",
                title: "我的",
                isSelected: selectedTab == 3
            ) {
                selectedTab = 3
            }
        }
    }

    private var tabBarBackground: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white.opacity(0.5))
            .shadow(
                color: .black.opacity(0.1),
                radius: 10,
                x: 0,
                y: 5
            )
    }

    @ViewBuilder
    private var popupOverlay: some View {
        if let popupType = currentPopup {
            let popupBinding = Binding(
                get: { currentPopup != nil },
                set: { if !$0 { currentPopup = nil } }
            )

            if popupType == .settings || popupType == .messages {
                CustomPopupSide(
                    popupType: popupType,
                    isPresented: popupBinding
                )
            } else {
                CustomPopup(
                    popupType: popupType,
                    isPresented: popupBinding
                )
            }
        }
    }
}

struct TabButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(isSelected ? .black : .gray)

                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isSelected ? .black : .gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MainTabView().environmentObject(AppCoordinator())
}
