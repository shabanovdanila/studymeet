import SwiftUI

struct LoginView: View {
    @State var login: String
    @State var password: String
    var body: some View {
        NavigationStack {
            LoginWindowView(login: $login, password: $password)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255))
        }
    }
}

private struct LoginWindowView: View {
    @Binding var login: String
    @Binding var password: String
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                (Text("Study")
                    .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
                    .font(.custom("MontserratAlternates-Bold", size: 20))
                 + Text("Mate")
                    .foregroundColor(Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255))
                    .font(.custom("MontserratAlternates-Bold", size: 20)))
            }
            .padding(.top, 29)
            
            Text("Вход")
                .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
                .font(.custom("Montserrat-Bold", size: 18))
                .padding(.top, 65)
            
            TextField("Логин или email", text: $login)
                .padding()
                .frame(width: 323, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .overlay {
                        RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255), lineWidth: 1)
                    }
                .padding(.top, 15)
            
            TextField("Пароль", text: $password)
                .padding()
                .frame(width: 323, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .overlay {
                        RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255), lineWidth: 1)
                    }
                .padding(.top, 15)
            
            Text("Забыли пароль?")
                .foregroundColor(Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255))
                .font(.custom("Montserrat-Medium", size: 14))
                .padding(.top, 15)
            
            Text("Войти")
                .foregroundColor(Color.white)
                .font(.custom("Montserrat-Medium", size: 16))
                .padding(.leading, 55)
                .padding(.trailing, 54)
                .padding([.top, .bottom], 12)
                .background(Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.top, 15)
            
            Text("Регистрация")
                .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
                .font(.custom("Montserrat-Medium", size: 14))
                .padding(.top, 15)
            
            

        }
        .frame(width: 363, height: 500, alignment: .top)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        
    }
}

