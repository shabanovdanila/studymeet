import SwiftUI

struct RegistrationView: View {
    @State var login: String
    @State var password: String
    @State var checkPassword: String
    @State var name_surname: String
    @State var email: String
    
    @State var selectionCheckBox: Bool
    
    var body: some View {
        NavigationStack {
            RegistrationWindowView(login: $login, password: $password, checkPassword: $checkPassword, name_surname: $name_surname, email: $email, selectionCheckBox: $selectionCheckBox)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 219 / 255, green: 234 / 255, blue: 254 / 255))
        }
    }
}

private struct RegistrationWindowView: View {
    
    @Binding var login: String
    @Binding var password: String
    @Binding var checkPassword: String
    @Binding var name_surname: String
    @Binding var email: String
    
    @Binding var selectionCheckBox: Bool
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack{
                (Text("Study")
                    .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
                    .font(.custom("MontserratAlternates-Bold", size: 20))
                 + Text("Mate")
                    .foregroundColor(Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255))
                    .font(.custom("MontserratAlternates-Bold", size: 20)))
            }
            .padding(.top, 30)
            
            Text("Регистрация")
                .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
                .font(.custom("Montserrat-Bold", size: 18))
                .padding(.top, 29)
            
            TextField("Логин", text: $login)
                .padding()
                .frame(width: 323, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .overlay {
                        RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255), lineWidth: 1)
                    }
                .padding(.top, 15)
            
            TextField("Имя и фамилия", text: $name_surname)
                .padding()
                .frame(width: 323, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .overlay {
                        RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255), lineWidth: 1)
                    }
                .padding(.top, 15)
            
            
            TextField("Email", text: $email)
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
            
            TextField("Повторите пароль", text: $checkPassword)
                .padding()
                .frame(width: 323, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .overlay {
                        RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255), lineWidth: 1)
                    }
                .padding(.top, 15)
            
            HStack(spacing: 0) {
                CheckBox(cornerRadius: 5, frame: 20, action: {selectionCheckBox.toggle(); print(selectionCheckBox)}, isSelected: selectionCheckBox)
                Text("Вы соглашаетесь с Политикой Конфиденциальности")
                    .foregroundColor(Color.black)
                    .font(.custom("Montserrat-Regular", size: 10))
                    .padding(.leading, 5)
            }
            .padding(.top, 15)
            .offset(x: -9)
            
            Text("Регистрация")
                .foregroundColor(Color.white)
                .font(.custom("Montserrat-Medium", size: 16))
                .padding(.leading, 55)
                .padding(.trailing, 54)
                .padding([.top, .bottom], 12)
                .background(Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.top, 15)
            
            Text("Войти")
                .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
                .font(.custom("Montserrat-Medium", size: 14))
                .padding(.top, 15)
            

        }
        .frame(width: 363, height: 600, alignment: .top)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        
    }
}

private struct CheckBox: View {
    
    let cornerRadius: CGFloat
    let frame: CGFloat
    let action: () -> Void
    let isSelected: Bool
    
    var body: some View {
        Button(action: action) {
            if (!isSelected) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: frame, height: frame)
                    .foregroundColor(Color.white)
                    .overlay {
                            RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(Color(red: 235 / 255, green: 235 / 255, blue: 235 / 255), lineWidth: 1)
                        }
            } else {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .frame(width: frame, height: frame)
                        .foregroundColor(Color.white)
                    Image(systemName: "checkmark.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255))
                        .frame(width: frame, height: frame)
                        .zIndex(1)
                }
            }
        }
    }
}
