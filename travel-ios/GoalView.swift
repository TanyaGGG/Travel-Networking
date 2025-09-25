import CoreLocation
import MapKit
import SwiftUI

struct GoalView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var locationManager = LocationManager()
    @State private var selectedPeriod = "本周"

    private let periodOptions = ["本周", "最近一个月", "最近半年"]

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                // Map or error/loading state
                VStack(spacing: 0) {
                    if locationManager.authorizationStatus == .authorizedWhenInUse
                        || locationManager.authorizationStatus == .authorizedAlways
                    {
                        MapView(locationManager: locationManager)
                            .frame(height: geometry.size.height / 1.5)
                            .ignoresSafeArea()
                    } else if locationManager.authorizationStatus == .denied {
                        VStack(spacing: 15) {
                            Image(systemName: "location.slash")
                                .font(.system(size: 50))
                                .foregroundColor(.red.opacity(0.7))

                            Text("位置访问被拒绝")
                                .font(.headline)
                                .foregroundColor(.black)

                            Text("请在设置中允许位置访问以查看您的足迹")
                                .font(.subheadline)
                                .foregroundColor(.black.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                        .frame(height: geometry.size.height / 2)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.9))
                        .ignoresSafeArea()
                    } else {
                        VStack(spacing: 15) {
                            ProgressView()
                                .scaleEffect(1.5)

                            Text("正在获取位置...")
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        .frame(height: geometry.size.height / 2)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.9))
                        .ignoresSafeArea()
                    }

                    Spacer()
                }

                // Bottom rounded container
                VStack {
                    // Content area - add your content here later
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            Text("省份数")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("8")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }.padding().background(
                            Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.5)
                        ).cornerRadius(10)
                        HStack(spacing: 16) {
                            Text("城市数")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("18")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }.padding().background(
                            Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.5)
                        ).cornerRadius(10)
                        HStack(spacing: 16) {
                            Text("里程数")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text("4000km")
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }.padding().background(
                            Color(red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.5)
                        ).cornerRadius(10)
                        HStack(spacing: 16) {
                            HStack(spacing: 16) {
                                Text("勋章数")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("6")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }.padding().background(
                                Color(
                                    red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.5)
                            ).cornerRadius(10)
                            HStack(spacing: 16) {
                                Text("总排名")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text("666")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }.padding().background(
                                Color(
                                    red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.5)
                            ).cornerRadius(10)
                        }
                        HStack(spacing: 16) {
                            Menu {
                                ForEach(periodOptions, id: \.self) { option in
                                    Button(option) {
                                        selectedPeriod = option
                                    }
                                }
                            } label: {
                                HStack {
                                    Text(selectedPeriod)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .center)
                                    Image(systemName: "chevron.down")
                                        .foregroundColor(.black)
                                        .font(.caption)
                                }
                            }
                            .padding()
                            .background(
                                Color(
                                    red: 255 / 255, green: 255 / 255, blue: 255 / 255, opacity: 0.5)
                            )
                            .cornerRadius(10)
                            Button(action: {
                            }) {
                                Text("一键生成海报")
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }.buttonStyle(PlainButtonStyle())
                                .padding().background(
                                    Color(
                                        red: 255 / 255, green: 255 / 255, blue: 255 / 255,
                                        opacity: 0.5)
                                ).cornerRadius(10)
                        }
                    }

                    .padding(32)

                }
                .frame(maxWidth: .infinity)
                //.padding(.top, (geometry.size.height / 1.5) - 84)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 205 / 255, green: 217 / 255, blue: 122 / 255),
                                    Color(red: 137 / 255, green: 175 / 255, blue: 212 / 255),
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
                        .ignoresSafeArea(.all, edges: .bottom)
                )
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    coordinator.popMain()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    locationManager.requestLocation()
                }) {
                    Image(systemName: "location.circle")
                        .foregroundColor(.black)
                }
            }
        }
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

#Preview {
    GoalView()
}
