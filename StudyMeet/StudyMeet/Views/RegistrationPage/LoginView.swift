//
//  LoginView.swift
//  StudyMeet
//
//  Created by Данила Шабанов
//
import SwiftUI

struct LoginView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = LoginViewModel()
    @Binding var path: NavigationPath
    @Binding var currentScreen: CurrentScreen
    @EnvironmentObject private var userSession: UserSession
    
    // MARK: - Body
    var body: some View {
        LoginWindowView(
            viewModel: viewModel,
            navigateToMain: navigateToMainPage,
            navigateToRegistration: navigateToRegistrationPage
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal, 15)
        .background(Color.blueBackgroundSM)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            currentScreen = .login
        }
        .ignoresSafeArea(.keyboard)
    }
    
    // MARK: - Navigation Methods
    private func navigateToMainPage() {
        path.removeLast(path.count)
    }
    
    private func navigateToRegistrationPage() {
        path = NavigationPath()
        path.append(PathNavigator.registration)
    }
}

private struct LoginWindowView: View {
    
    // MARK: - Focus Field Enum
    enum Field: Hashable {
        case username
        case password
    }
    
    // MARK: - Properties
    @ObservedObject var viewModel: LoginViewModel
    @FocusState private var focusedField: Field?
    var navigateToMain: () -> Void
    var navigateToRegistration: () -> Void
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            appLogo
                .padding(.top, 30)
            
            Text("Вход")
                .foregroundColor(Color.darkBlueSM)
                .font(.montserrat("Bold", size: 18, relativeTo: .title2))
                .minimumScaleFactor(0.8)
                .padding(.top, 65)
            
            fields()
            
            Text("Забыли пароль?")
                .foregroundColor(Color.lightBlueSM)
                .font(.montserrat("Medium", size: 14, relativeTo: .callout))
                .minimumScaleFactor(0.8)
                .padding(.top, 15)
            
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 15)
            } else {
                Button(action: {
                    Task {
                        if viewModel.validateFields(), await viewModel.login() {
                            navigateToMain()
                        }
                    }
                }) {
                    Text("Войти")
                        .font(.montserrat("Medium", size: 16, relativeTo: .body))
                        .minimumScaleFactor(0.8)
                        .frame(maxWidth: 200)
                        .padding(.vertical, 12)
                        .background(Color.lightBlueSM)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .padding(.top, 15)
                }
            }
            
            Button("Регистрация") {
                withTransaction(Transaction(animation: nil)) {
                    navigateToRegistration()
                }
            }
            .foregroundColor(Color.darkBlueSM)
            .font(.montserrat("Medium", size: 14, relativeTo: .body))
            .minimumScaleFactor(0.8)
            .padding(.top, 15)
        }
        .frame(height: 500, alignment: .top)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
    
    // MARK: - Fields
    @ViewBuilder
    private func fields() -> some View {
        VStack(spacing: 0) {
            TextField("Логин", text: $viewModel.usernameOrEmail)
                .focused($focusedField, equals: .username)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }
                .font(.montserrat("Regular", size: 14, relativeTo: .body))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .registrationTextFieldStyle()
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.graySM, lineWidth: 1)
                )
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.lightBlueSM)
                        .padding(.trailing, 10)
                        .opacity(viewModel.usernameOrEmail.isEmpty ? 0 : 1)
                        .onTapGesture {
                            viewModel.usernameOrEmail = ""
                            UIApplication.shared.endEditing()
                        },
                    alignment: .trailing
                )
                .padding([.top, .horizontal], 15)
            if let error = viewModel.usernameError {
                Text(error)
                    .font(.montserrat("Regular", size: 12))
                    .foregroundColor(.redReportSM)
                    .padding(.top, 4)
            }
            
            SecureField("Пароль", text: $viewModel.password)
                .focused($focusedField, equals: .password)
                .submitLabel(.go)
                .onSubmit {
                    Task {
                        if await viewModel.login() {
                            navigateToMain()
                        }
                    }
                }
                .font(.montserrat("Regular", size: 14, relativeTo: .body))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .registrationTextFieldStyle()
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.graySM, lineWidth: 1)
                )
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.lightBlueSM)
                        .padding(.trailing, 10)
                        .opacity(viewModel.password.isEmpty ? 0 : 1)
                        .onTapGesture {
                            viewModel.password = ""
                            UIApplication.shared.endEditing()
                        },
                    alignment: .trailing
                )
                .padding([.top, .horizontal], 15)
            if let error = viewModel.passwordError {
                Text(error)
                    .font(.montserrat("Regular", size: 12))
                    .foregroundColor(.redReportSM)
                    .padding(.top, 4)
            }
            if let error = viewModel.error {
                Text("Аккаунт не найден")
                    .font(.montserrat("Regular", size: 14))
                    .foregroundColor(.redReportSM)
                    .padding(.top, 4)
            }
        }
    }
    
    // MARK: - App Logo
    private var appLogo: some View {
        (Text("Study")
            .foregroundColor(Color.darkBlueSM)
            .font(.montserratAlt("Bold", size: 20, relativeTo: .title2))
         + Text("Meet")
            .foregroundColor(Color.lightBlueSM)
            .font(.montserratAlt("Bold", size: 20, relativeTo: .title2)))
            .minimumScaleFactor(0.8)
    }
}

private struct Hint: View {
    let hintText: String = "Логин слишком короткий"
    var body: some View {
        VStack {
            Text(hintText)
        }
    }
}

#Preview {
    @State var path = NavigationPath()
    @State var currentScreen: CurrentScreen = .login

    return LoginView(path: $path, currentScreen: $currentScreen)
        .environmentObject(UserSession.shared)

}
