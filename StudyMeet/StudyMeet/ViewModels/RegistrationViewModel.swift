//
//  RegistrationViewModel.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 20.04.2025.
//

import Foundation
import SwiftUI

final class RegistrationViewModel: ObservableObject {
    private let authClient: AuthClient
    private let userSession: UserSession = .shared
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var checkPassword: String = ""
    @Published var name: String = ""
    @Published var email: String = ""
    @Published var selectionCheckBox: Bool = false
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    init(authClient: AuthClient = AuthClient()) {
        self.authClient = authClient
    }
    
    @MainActor
    func register() async -> Bool {
        guard validateFields() else { return false }
        guard !isLoading else { return false }
        
        isLoading = true
        error = nil
        
        do {
            let nameComponents = name.components(separatedBy: " ")
            let name = nameComponents.first ?? ""
            let surname = nameComponents.count > 1 ? nameComponents[1] : ""
            
            let authResponse: Auth = try await authClient.register(
                email: email,
                password: password,
                name: "\(name) \(surname)",
                username: username
            )
            
            print("Registration successful: \(authResponse)")
            isLoading = false
            
            if let user = authResponse.user {
                print("success login usersession")
                userSession.login(user: user)
            }
            return true
            
        } catch {
            self.error = error
            isLoading = false
            print("Registration failed: \(error)")
            return false
        }
    }
    
    private func validateFields() -> Bool {
        error = nil
        
        guard !username.isEmpty else {
            error = RegistrationError.emptyLogin
            return false
        }
        
        guard !name.isEmpty else {
            error = RegistrationError.emptyName
            return false
        }
        
        guard !email.isEmpty, email.contains("@"), email.contains(".") else {
            error = RegistrationError.invalidEmail
            return false
        }
        
        guard !password.isEmpty, password.count >= 6 else {
            error = RegistrationError.shortPassword
            return false
        }
        
        guard password == checkPassword else {
            error = RegistrationError.passwordsDontMatch
            return false
        }
        
        guard selectionCheckBox else {
            error = RegistrationError.termsNotAccepted
            return false
        }
        
        return true
    }
}

private enum RegistrationError: LocalizedError {
    case emptyLogin
    case emptyName
    case invalidEmail
    case shortPassword
    case passwordsDontMatch
    case termsNotAccepted
    
    var errorDescription: String? {
        switch self {
        case .emptyLogin:
            return "Пожалуйста, введите логин"
        case .emptyName:
            return "Пожалуйста, введите имя и фамилию"
        case .invalidEmail:
            return "Пожалуйста, введите корректный email"
        case .shortPassword:
            return "Пароль должен содержать минимум 6 символов"
        case .passwordsDontMatch:
            return "Пароли не совпадают"
        case .termsNotAccepted:
            return "Пожалуйста, согласитесь с Политикой Конфиденциальности"
        }
    }
}
