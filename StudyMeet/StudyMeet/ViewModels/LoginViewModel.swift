//
//  LoginViewModel.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 03.06.2025.
//

import Foundation
import SwiftUI

final class LoginViewModel: ObservableObject {
    private let authClient: AuthClient
    private let userSession: UserSession = .shared
    
    @Published var usernameOrEmail: String = "" {
        didSet {
            usernameError = nil
        }
    }
    @Published var password: String = "" {
        didSet {
            passwordError = nil
        }
    }
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var usernameError: String?
    @Published var passwordError: String?
    
    init(authClient: AuthClient = DependencyContainer.shared.makeAuthClient()) {
        self.authClient = authClient
    }
    
    @MainActor
    func login() async -> Bool {
        guard validateFields() else { return false }
        guard !isLoading else { return false }
        
        isLoading = true
        error = nil
        
        do {
            let authResponse: Auth = try await authClient.login(email: usernameOrEmail, password: password)
            
            isLoading = false
            
            if let user = authResponse.user {
                userSession.login(user: user)
            }
            return true
            
        } catch {
            self.error = error
            isLoading = false
            print("Login failed: \(error)")
            return false
        }
    }
    
    func validateFields() -> Bool {
        usernameError = nil
        passwordError = nil
        
        var isValid = true
        
        if usernameOrEmail.isEmpty || usernameOrEmail.count < 4 {
            usernameError = LoginError.emptyLogin.rawValue
            isValid = false
        }
        if password.isEmpty || password.count < 6 {
            passwordError = LoginError.shortPassword.rawValue
            isValid = false
        }
        return isValid
    }
}

private enum LoginError: String {
    case emptyLogin = "Аккаунт не найден"
    case shortPassword = "Пароль должен содержать минимум 6 символов"
}
