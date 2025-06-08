import SwiftUI

struct LoginView: View {
    
    @StateObject private var viewModel = LoginViewModel()
    @Binding var path: NavigationPath
    @Binding var currentScreen: CurrentScreen
    @EnvironmentObject private var userSession: UserSession
    
    var body: some View {
        LoginWindowView(viewModel: viewModel, navigateToMain: navigateToMainPage,
                        navigateToRegistration: navigateToRegistrationPage)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blueBackgroundSM)
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
            .navigationBarBackButtonHidden(true)
            .onAppear {
                currentScreen = .registration
            }
            .ignoresSafeArea(.keyboard)
    }
    private func navigateToMainPage() {
        path = NavigationPath()
        path.append(Path.main)
    }
    private func navigateToRegistrationPage() {
//        if !path.isEmpty {
//            path.removeLast()
//        }
        path = NavigationPath()
        path.append(Path.registration)
    }
}

private struct LoginWindowView: View {
    @ObservedObject var viewModel: LoginViewModel
    var navigateToMain: () -> Void
    var navigateToRegistration: () -> Void
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack {
                (Text("Study")
                    .foregroundColor(Color.darkBlueSM)
                    .font(.custom("MontserratAlternates-Bold", size: 20))
                 + Text("Meet")
                    .foregroundColor(Color.lightBlueSM)
                    .font(.custom("MontserratAlternates-Bold", size: 20)))
            }
            .padding(.top, 29)
            
            Text("Вход")
                .foregroundColor(Color.darkBlueSM)
                .font(.custom("Montserrat-Bold", size: 18))
                .padding(.top, 65)
            
            Group {
                fields()
            }
            .frame(width: 323, height: 40)
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Color.graySM, lineWidth: 1)
            )
            .padding(.top, 15)
            
            Text("Забыли пароль?")
                .foregroundColor(Color.lightBlueSM)
                .font(.custom("Montserrat-Medium", size: 14))
                .padding(.top, 15)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 15)
            } else {
                Button(action: {
                    Task {
                        if await viewModel.login() {
                            navigateToMain()
                        }
                        else {
                            print(11111)
                        }
                    }
                }) {
                    Text("Войти")
                        .frame(width: 200)
                        .padding(.vertical, 12)
                        .background(Color.lightBlueSM)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .padding(.top, 15)
            }
            
            Button("Регистрация") {
                withAnimation(.none) {
                    navigateToRegistration()
                }
            }
                .foregroundColor(Color.darkBlueSM)
                .font(.custom("Montserrat-Medium", size: 14))
                .padding(.top, 15)
            
            

        }
        .frame(width: 363, height: 500, alignment: .top)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
        
    }
    
    @ViewBuilder
    private func fields() -> some View {
        Group {
            TextField("Логин", text: $viewModel.usernameOrEmail)
            SecureField("Пароль", text: $viewModel.password)
        }
        .autocapitalization(.none)
        .registrationTextFieldStyle()
    }
    
}

