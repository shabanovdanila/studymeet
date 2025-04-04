import SwiftUI

struct ContentView: View {

    @State var isLogin: Bool = true
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
                TopBarView(isLogin: isLogin, isInUserPageView: false)
                .background(Color.white)
                ScrollView(showsIndicators: false) {
                    VStack {
                        SearcherView(searchText: $searchText)
                            .padding(.top, 15)
                        ForEach(0..<6) {_ in
                            AnnounceCardView(announce: Announcement(id: 1, title: "Ищу по англу", bg_color: "hsl(350, 98%, 79%)", user_id: 1, user_name: "Emilia lin", description: "Hi everyyy", tags: [Tag(id: 1, name: "English", color: "hsl(350, 98%, 79%)")], liked: false))
                                .padding(.top, 15)
                        }
                    }
                    .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity)
                .background(Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255))
                
                if isLogin {
                    BottomBarView(page1: page1)
                }
            }
        }
        .background(Color.white)
    }
}
