
import SwiftUI

struct TopBarView: View {
    
    @Binding var path: NavigationPath
    @Binding var isLogin: Bool
    @Binding var currentScreen: CurrentScreen
    
    
    private var isOnMainPage: Bool {
        currentScreen == .main
    }
    
    private var isOnUserPage: Bool {
        currentScreen == .user
    }

    var body: some View {
        HStack {
            
            if isOnMainPage {
                appLogo
            } else {
                Button(action: returnToMainPage) {
                    appLogo
                }
            }
            
            Spacer()
            
            if !isLogin {
                Text("Войти")
                    .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
                    .font(.custom("Montserrat-Medium", size: 16))
                    .padding([.bottom, .top], 13)
                    .padding(.horizontal, 15)
            } else {
                HStack {
                    Image(systemName: "plus")
                        .resizable()
                        .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
                        .frame(width: 25, height: 25)
                        .padding(.trailing, 15)
                    Image(systemName: "bell")
                        .resizable()
                        .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
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
        path.append(Path.user)
    }
    
    private var appLogo: some View {
        (Text("Study")
            .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
            .font(.custom("MontserratAlternates-Bold", size: 20))
         + Text("Meet")
            .foregroundColor(Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255))
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

