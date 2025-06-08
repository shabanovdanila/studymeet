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
    
    @Published var usernameOrEmail: String = ""
    @Published var password: String = ""
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
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
    
    private func validateFields() -> Bool {
        error = nil
        
        guard !usernameOrEmail.isEmpty else {
            error = LoginError.emptyLogin
            return false
        }
        
        guard !password.isEmpty, password.count >= 6 else {
            error = LoginError.shortPassword
            return false
        }
        
        return true
    }
}

private enum LoginError: LocalizedError {
    case emptyLogin
    case shortPassword
    
    var errorDescription: String? {
        switch self {
        case .emptyLogin:
            return "Пожалуйста, введите корректный логин"
        case .shortPassword:
            return "Пароль должен содержать минимум 6 символов"
        }
    }
}
