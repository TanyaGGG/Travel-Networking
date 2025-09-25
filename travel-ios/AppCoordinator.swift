import SwiftUI

enum AppFlow { case auth, main }
enum AuthRoute: Hashable { case verify }
enum MainRoute: Hashable {
    case goal
    case userProfile(userId: String, userName: String)
}

final class AppCoordinator: ObservableObject {
    // High-level app flow (auth vs main)
    @Published var appFlow: AppFlow = .auth

    // Separate navigation paths for each flow
    @Published var authPath = NavigationPath()
    @Published var mainPath = NavigationPath()

    // Auth navigation
    func pushAuth(_ route: AuthRoute) { authPath.append(route) }
    func popAuth() { authPath.removeLast() }
    func popAuthToRoot() { authPath = NavigationPath() }

    // Main navigation
    func pushMain(_ route: MainRoute) { mainPath.append(route) }
    func popMain() { mainPath.removeLast() }
    func popMainToRoot() { mainPath = NavigationPath() }

    // Flow transitions
    func transitionToMain() {
        // Clear auth path and switch to main flow
        authPath = NavigationPath()
        appFlow = .main
    }

    func logout() {
        // Clear all navigation and return to auth
        authPath = NavigationPath()
        mainPath = NavigationPath()
        appFlow = .auth
    }
}

struct AppCoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator()

    var body: some View {
        Group {
            switch coordinator.appFlow {
            case .auth:
                NavigationStack(path: $coordinator.authPath) {
                    LoginView()
                        .environmentObject(coordinator)
                        .navigationDestination(for: AuthRoute.self) { route in
                            switch route {
                            case .verify:
                                VerifyView()
                                    .environmentObject(coordinator)
                            }
                        }
                }

            case .main:
                NavigationStack(path: $coordinator.mainPath) {
                    MainTabView()
                        .environmentObject(coordinator)
                        .navigationDestination(for: MainRoute.self) { route in
                            switch route {
                            case .goal:
                                GoalView()
                                    .environmentObject(coordinator)
                            case .userProfile(let userId, let userName):
                                UserProfileView(userId: userId, userName: userName)
                                    .environmentObject(coordinator)
                            }
                        }
                }
            }
        }
    }
}
