import SwiftUI


enum Path: Hashable {
    case main
    case userOwn
    case userAnother(userId: Int)
    case login
    case registration
}

enum CurrentScreen {
    case main
    case userOwn
    case userAnother
    case login
    case registration
}

struct ContentView: View {
    
    @State var path = NavigationPath()
    @State private var currentScreen: CurrentScreen = .main
    @EnvironmentObject var userSession: UserSession
    
    @State var isLogin: Bool = true
    
    var body: some View {
        
        NavigationStack(path: $path) {
            
            Group {
                if userSession.isAuthenticated {
                    MainPageView(path: $path, currentScreen: $currentScreen)
                } else {
                    RegistrationView(path: $path, currentScreen: $currentScreen)
                }
            }
            .navigationDestination(for: Path.self) { route in
                switch route {
                case .main:
                    MainPageView(path: $path, currentScreen: $currentScreen )
                case .userOwn:
                    UserPageView(path: $path, currentScreen: $currentScreen, user: userSession.currentUser!)
                case .userAnother(let userId):
                    AnotherUserPageView(userId: userId, path: $path, currentScreen: $currentScreen)
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
