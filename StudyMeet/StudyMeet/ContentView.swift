import SwiftUI


enum PathNavigator: Hashable {
    case main
    case userOwn
    case ownAnnounce(announcementId: Int)
    case userAnother(userId: Int)
    case anotherAnnounce(announcementId: Int, userId: Int)
    case chatList
    case chatDetail(chatId: Int)
    case login
    case registration
    //case forgotPassword
}

enum CurrentScreen {
    case main
    case userOwn
    case ownAnnounce
    case userAnother
    case anotherAnnounce
    case chatList
    case chatDetail
    case login
    case registration
}

struct ContentView: View {
    
    @State var path = NavigationPath()
    @State private var currentScreen: CurrentScreen = .main
    @EnvironmentObject var userSession: UserSession
    
    var body: some View {
        
        NavigationStack(path: $path) {
            
            Group {
                if userSession.isAuthenticated {
                    MainTabView(path: $path, currentScreen: $currentScreen)
                } else {
                    RegistrationView(path: $path, currentScreen: $currentScreen)
                }
            }
            .navigationDestination(for: PathNavigator.self) { route in
                switch route {
                case .main:
                    MainPageView(path: $path, currentScreen: $currentScreen )
                case .userOwn:
                    OwnUserPageView(path: $path, currentScreen: $currentScreen)
                case .ownAnnounce(let announcementId):
                    AnnounceOwnPageView(path: $path, currentScreen: $currentScreen, announcementId: announcementId)
                case .userAnother(let userId):
                    AnotherUserPageView(userId: userId, path: $path, currentScreen: $currentScreen)
                case .login:
                    LoginView(path: $path, currentScreen: $currentScreen)
                case .registration:
                    RegistrationView(path: $path, currentScreen: $currentScreen)
                case .anotherAnnounce(let announcementId, let userId):
                    AnnounceAnotherPageView(path: $path, currentScreen: $currentScreen, announcementId: announcementId, userId: userId)
                case .chatList:
                    ChatListView(path: $path, currentScreen: $currentScreen)
                case .chatDetail(let chatId):
                    ChatDetailView(chatId: chatId)
                }
            }
        }
        .background(.white)
    }
    
}
