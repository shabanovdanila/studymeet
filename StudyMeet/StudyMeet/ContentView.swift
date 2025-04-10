import SwiftUI


enum Path: Hashable {
    case main
    case user
}

enum CurrentScreen {
    case main
    case user
}

struct ContentView: View {

    //RegistrationView(login: login, password: password, checkPassword: checkPassword, name_surname: name_surname, email: email, selectionCheckBox: selectionCheckBox)
    //LoginView(login: login, password: password)
    
    @State var login: String = ""
    @State var password: String = ""
    @State var checkPassword: String = ""
    @State var name_surname: String = ""
    @State var email: String = ""
    @State var searchText: String = ""
    
    @State var selectionCheckBox: Bool = false
    
    
    //
    @State var path = NavigationPath()
    @State private var currentScreen: CurrentScreen = .main
    
    
    
    @State var isLogin: Bool = true
    
    var body: some View {
            NavigationStack(path: $path) {
                MainPageView(path: $path, currentScreen: $currentScreen, isLogin: $isLogin)
                    .navigationDestination(for: Path.self) { route in
                        switch route {
                        case .main:
                            MainPageView(path: $path, currentScreen: $currentScreen, isLogin: $isLogin)
                        case .user:
                            UserPageView(path: $path, currentScreen: $currentScreen, isLogin: $isLogin)
                        }
                    }
            }
        }
}
