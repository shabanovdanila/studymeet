import SwiftUI

import SwiftUI

struct RegistrationView: View {
    
    @StateObject private var viewModel = RegistrationViewModel()
    @Binding var path: NavigationPath
    @Binding var currentScreen: CurrentScreen
    @EnvironmentObject private var userSession: UserSession
    
    var body: some View {
        RegistrationWindowView(viewModel: viewModel, navigateTo: {
            navigateToMainPage()
        })
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 219/255, green: 234/255, blue: 254/255))
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
            .alert(isPresented: .constant(viewModel.error != nil)) {
                Alert(
                    title: Text("Ошибка"),
                    message: Text(viewModel.error?.localizedDescription ?? "Неизвестная ошибка"),
                    dismissButton: .default(Text("OK")) {
                        viewModel.error = nil
                    }
                )
            }
            .onAppear {
                currentScreen = .registration
            }
    }
    private func navigateToMainPage() {
        path.append(Path.main)
    }
}

private struct RegistrationWindowView: View {
    @ObservedObject var viewModel: RegistrationViewModel
    var navigateTo: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack{
                (Text("Study")
                    .foregroundColor(Color(red: 30 / 255, green: 58 / 255, blue: 138 / 255))
                    .font(.custom("MontserratAlternates-Bold", size: 20))
                 + Text("Meet")
                    .foregroundColor(Color(red: 59 / 255, green: 130 / 255, blue: 246 / 255))
                    .font(.custom("MontserratAlternates-Bold", size: 20)))
            }
            .padding(.top, 30)
            
            Text("Регистрация")
                .foregroundColor(Color(red: 30/255, green: 58/255, blue: 138/255))
                .font(.custom("Montserrat-Bold", size: 18))
                .padding(.top, 29)
            
            Group {
                fields()
            }
            .frame(width: 323, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color(red: 235/255, green: 235/255, blue: 235/255), lineWidth: 1)
            )

            .padding(.top, 15)
            
            // Чекбокс соглашения
            HStack(spacing: 0) {
                CheckBox(
                    cornerRadius: 5,
                    frame: 20,
                    action: { viewModel.selectionCheckBox.toggle() },
                    isSelected: viewModel.selectionCheckBox
                )
                Text("Вы соглашаетесь с Политикой Конфиденциальности")
                    .foregroundColor(.black)
                    .font(.custom("Montserrat-Regular", size: 10))
                    .padding(.leading, 5)
            }
            .padding(.top, 15)
            .offset(x: -9)
            
            // Кнопка регистрации
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 15)
            } else {
                Button(action: {
                    Task {
                        if await viewModel.register() {
                            
                            navigateTo()
                        }
                        else {
                            print(11111)
                        }
                    }
                }) {
                    Text("Регистрация")
                        .frame(width: 200)
                        .padding(.vertical, 12)
                        .background(Color(red: 59/255, green: 130/255, blue: 246/255))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.top, 15)
            }
            
            // Кнопка входа
            Button("Войти") {
                //navigateTo()
            }
            .foregroundColor(Color(red: 30/255, green: 58/255, blue: 138/255))
            .font(.custom("Montserrat-Medium", size: 14))
            .padding(.top, 15)
        }
        .padding(.horizontal)
        .frame(width: 363, height: 600)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
    
    @ViewBuilder
    private func fields() -> some View {
        Group {
            TextField("Логин", text: $viewModel.username)
            TextField("Имя и фамилия", text: $viewModel.name)
            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
            SecureField("Пароль", text: $viewModel.password)
            SecureField("Повторите пароль", text: $viewModel.checkPassword)
        }
        .autocapitalization(.none)
        .registrationTextFieldStyle()
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
