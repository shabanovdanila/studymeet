import SwiftUI


enum Path: Hashable {
    case main
    case user
    case login
    case registration
}

enum CurrentScreen {
    case main
    case user
    case login
    case registration
}

struct ContentView: View {
    
    @State var path = NavigationPath()
    @State private var currentScreen: CurrentScreen = .main
    
    @StateObject private var userSession = UserSession.shared
    
    @State var isLogin: Bool = true
    
    var body: some View {
        
        NavigationStack(path: $path) {
            
            Group {
                if userSession.isAuthenticated {
                    MainPageView(path: $path, currentScreen: $currentScreen, isLogin: $isLogin)
                } else {
                    RegistrationView(path: $path, currentScreen: $currentScreen)
                }
            }
            .navigationDestination(for: Path.self) { route in
                switch route {
                case .main:
                    MainPageView(path: $path, currentScreen: $currentScreen, isLogin: $isLogin)
                case .user:
                    UserPageView(path: $path, currentScreen: $currentScreen, isLogin: $isLogin)
                    
                case .login:
                    //LoginView(login: $login, password: <#T##String#>)
                    EmptyView()
                case .registration:
                    RegistrationView(path: $path, currentScreen: $currentScreen)
                }
            }
        }
    }
    
}
