//
//  RegistrationView.swift
//  StudyMeet
//
//  Created by Данила Шабанов
//
import SwiftUI

struct RegistrationView: View {
    
    // MARK: - Properties
    @StateObject private var viewModel = RegistrationViewModel()
    @Binding var path: NavigationPath
    @Binding var currentScreen: CurrentScreen
    @EnvironmentObject private var userSession: UserSession
    
    // MARK: - Body
    var body: some View {
        RegistrationWindowView(viewModel: viewModel, navigateToMain:navigateToMainPage,
                               navigateToLogin: navigateToLoginPage)
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
                currentScreen = .login
            }
            .ignoresSafeArea(.keyboard)
    }
    
    // MARK: - Navigation Methods
    private func navigateToMainPage() {
        path.removeLast(path.count)
    }
    private func navigateToLoginPage() {
        path = NavigationPath()
        path.append(PathNavigator.login)
    }
}

private struct RegistrationWindowView: View {
    
    // MARK: - Focus Field Enum
    enum Field: Hashable {
        case username, name, email
    }
    
    // MARK: - Properties
    @ObservedObject var viewModel: RegistrationViewModel
    var navigateToMain: () -> Void
    var navigateToLogin: () -> Void
    @FocusState private var focusedField: Field?
    
    // MARK: - Body
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
            .padding(.top, 30)
            
            Text("Регистрация")
                .foregroundColor(Color.darkBlueSM)
                .font(.custom("Montserrat-Bold", size: 18))
                .padding(.top, 29)
            
            fields()
                .frame(maxWidth: .infinity)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.graySM, lineWidth: 1)
                )
                .padding([.top, .horizontal], 15)
            
            termsCheckBox
            
            if viewModel.isLoading {
                ProgressView()
                    .padding(.top, 15)
            } else {
                registrationButton
                    .padding(.top, 15)
            }
            
            loginButton
                .padding(.top, 15)
        }
        .padding(.horizontal)
        .frame(width: 363, height: 600)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
    
    // MARK: - Fields View
    @ViewBuilder
    private func fields() -> some View {
        Group {
            TextField("Логин", text: $viewModel.username)
                .focused($focusedField, equals: .username)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .name
                }

            TextField("Имя и фамилия", text: $viewModel.name)
                .focused($focusedField, equals: .name)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .email
                }

            TextField("Email", text: $viewModel.email)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)

            SecureField("Пароль", text: $viewModel.password)

            SecureField("Повторите пароль", text: $viewModel.checkPassword)
                .onSubmit {
                    Task {
                        if await viewModel.register() {
                            navigateToMain()
                        }
                    }
                }
        }
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .registrationTextFieldStyle()
    }
    
    // MARK: - Terms Checkbox
    private var termsCheckBox: some View {
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
    }
    
    // MARK: - Registration Button
    private var registrationButton: some View {
        Button(action: {
            Task {
                if await viewModel.register() {
                    navigateToMain()
                }
            }
        }) {
            Text("Регистрация")
                .frame(width: 200)
                .padding(.vertical, 12)
                .background(Color.lightBlueSM)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }
    
    // MARK: - Login Button
    private var loginButton: some View {
        Button("Войти") {
            withTransaction(Transaction(animation: nil)) {
                navigateToLogin()
            }
        }
        .foregroundColor(Color.darkBlueSM)
        .font(.custom("Montserrat-Medium", size: 14))
    }
}

private struct CheckBox: View {
    
    // MARK: - Properties
    let cornerRadius: CGFloat
    let frame: CGFloat
    let action: () -> Void
    let isSelected: Bool
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            if (!isSelected) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: frame, height: frame)
                    .foregroundColor(Color.white)
                    .overlay {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .strokeBorder(Color.graySM, lineWidth: 1)
                    }
            } else {
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .frame(width: frame, height: frame)
                        .foregroundColor(Color.white)
                    Image(systemName: "checkmark.square.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(Color.lightBlueSM)
                        .frame(width: frame, height: frame)
                        .zIndex(1)
                }
            }
        }
    }
}
