import SwiftUI

struct HomeView: View {
    @State private var name: String = ""
    @State private var idCard: String = ""
    @State private var isButtonsMinimized: Bool = false
    @State private var isMusicToggled: Bool = false
    @State private var isWaveformToggled: Bool = false

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    Image("home-bg")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width * 2,
                            height: geometry.size.height
                        )
                        .clipped()
                }
                .ignoresSafeArea(.all)
                .scrollDisabled(false)

            }
            .ignoresSafeArea(.all)
            VStack {
                VStack {
                    HStack {
                        Spacer()
                        HStack {
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isButtonsMinimized.toggle()
                                }
                            }) {
                                Image(
                                    systemName: isButtonsMinimized
                                        ? "chevron.left" : "chevron.right"
                                )

                                .padding(12)
                                .background(
                                    Color.white.opacity(0.1)
                                )
                                .cornerRadius(10)
                            }.buttonStyle(PlainButtonStyle())
                            if !isButtonsMinimized {
                                Button(action: {
                                    print("Basket")
                                }) {
                                    ZStack {
                                        Color(
                                            red: 255 / 255,
                                            green: 255 / 255,
                                            blue: 255 / 255,
                                            opacity: 0.5
                                        )
                                        .cornerRadius(10)
                                        Image(systemName: "camera")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                            .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: 40, maxHeight: 40)
                                }
                                .buttonStyle(PlainButtonStyle())
                                Button(action: {
                                    print("Suitcase")
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
                                            systemName: "mappin.and.ellipse"
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
                                    isMusicToggled.toggle()
                                }) {
                                         ZStack {
                                        Color(
                                            red: 255 / 255,
                                            green: 255 / 255,
                                            blue: 255 / 255,
                                            opacity: isMusicToggled ? 1.0 : 0.5
                                        )
                                        .cornerRadius(10)
                                        Image(
                                            systemName: "music.note"
                                        )
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.black)
                                    }
                                    .frame(maxWidth: 40, maxHeight: 40)
                                }.buttonStyle(PlainButtonStyle())
                                Button(action: {
                                    isWaveformToggled.toggle()
                                }) {
                                         ZStack {
                                        Color(
                                            red: 255 / 255,
                                            green: 255 / 255,
                                            blue: 255 / 255,
                                            opacity: isWaveformToggled ? 1.0 : 0.5
                                        )
                                        .cornerRadius(10)
                                        Image(
                                            systemName: "waveform"
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
    }
}

#Preview {
    HomeView()
}
