
import SwiftUI

struct TopBarView: View {
    
    @Binding var path: NavigationPath
    @Binding var currentScreen: CurrentScreen
    
    @EnvironmentObject private var userSession: UserSession
    
    var onCreateButtonTapped: () -> Void
    
    var scrollToTop: (() -> Void)?
    
    private var isOnMainPage: Bool {
        currentScreen == .main
    }
    
    private var isOnUserPage: Bool {
        currentScreen == .userOwn
    }

    var body: some View {
        HStack {
            
            if isOnMainPage {
                Button(action: { scrollToTop?()} ) {
                    appLogo
                }
            } else {
                Button(action: returnToMainPage) {
                    appLogo
                }
            }
            
            Spacer()
            
            if !userSession.isAuthenticated {
                Text("Войти")
                    .foregroundColor(Color.darkBlueSM)
                    .font(.custom("Montserrat-Medium", size: 16))
                    .padding([.bottom, .top], 13)
                    .padding(.horizontal, 15)
            } else {
                HStack {
                    
                    Button(action: onCreateButtonTapped) {
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundColor(Color.darkBlueSM)
                            .frame(width: 25, height: 25)
                    }
                    .padding(.trailing, 15)
                    
                    Image(systemName: "bell")
                        .resizable()
                        .foregroundColor(Color.darkBlueSM)
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 15)
                    
                    if isOnUserPage {
                        avatar
                            .padding(.trailing, 15)
                    } else {
                        Button(action: navigateToUserPage) {
                            avatar
                        }
                        .padding(.trailing, 15)
                    }
                    
                }
                .padding([.bottom, .top], 10)
            }
        }
        .frame(width: 393, height: 50)
    }
    
    
    private func returnToMainPage() {
        path.removeLast(path.count)
    }
    private func navigateToUserPage() {
        path.append(PathNavigator.userOwn)
    }
    
    private var appLogo: some View {
        (Text("Study")
            .foregroundColor(Color.darkBlueSM)
            .font(.custom("MontserratAlternates-Bold", size: 20))
         + Text("Meet")
            .foregroundColor(Color.lightBlueSM)
            .font(.custom("MontserratAlternates-Bold", size: 20)))
        .padding([.bottom, .top], 10)
        .padding(.leading, 15)
    }
    
    private var avatar: some View {
        Image(systemName: "cat.fill")
            .resizable()
            .padding(3)
            .frame(width: 25, height: 25)
            .background(Color.yellow)
            .clipShape(Circle())
    }
}

