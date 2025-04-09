import SwiftUI

struct ContentView: View {

    @State var isLogin: Bool = true
    @State var isInUserPageView: Bool = false
    @State var page1: Bool = true
    
    @State var login: String = ""
    @State var password: String = ""
    @State var checkPassword: String = ""
    @State var name_surname: String = ""
    @State var email: String = ""
    @State var searchText: String = ""
    
    @State var selectionCheckBox: Bool = false
    
    private var userClient = UserClient()
    
    var body: some View {
        
        //RegistrationView(login: login, password: password, checkPassword: checkPassword, name_surname: name_surname, email: email, selectionCheckBox: selectionCheckBox)
        //LoginView(login: login, password: password)
        VStack(spacing: 0) {
            NavigationStack {
                TopBarView(isLogin: $isLogin, isInUserPageView: $isInUserPageView)
                .background(Color.white)
                
                AnnouncementsScrollView(viewModel: .init(client: AnnouncClient()), searchText: $searchText)
                
                .frame(maxWidth: .infinity)
                
                if isLogin {
                    BottomBarView(page1: page1)
                }
            }
        }
        .background(Color.white)
    }
}
