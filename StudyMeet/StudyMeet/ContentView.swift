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

    //RegistrationView(login: login, password: password, checkPassword: checkPassword, name_surname: name_surname, email: email, selectionCheckBox: selectionCheckBox)
    //LoginView(login: login, password: password)
    
    //
    @State var path = NavigationPath()
    @State private var currentScreen: CurrentScreen = .main
    
    
    
    @State var isLogin: Bool = true
    
    var body: some View {
        
        RegistrationView()
//        
//            NavigationStack(path: $path) {
//                MainPageView(path: $path, currentScreen: $currentScreen, isLogin: $isLogin)
//                    .navigationDestination(for: Path.self) { route in
//                        switch route {
//                        case .main:
//                            MainPageView(path: $path, currentScreen: $currentScreen, isLogin: $isLogin)
//                        case .user:
//                            UserPageView(path: $path, currentScreen: $currentScreen, isLogin: $isLogin)
//                        }
//                    }
//            }
        }
}
