//
//  UserSession.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 20.04.2025.
//

import Foundation

final class UserSession: ObservableObject {
    static let shared = UserSession()
    private let authClient = AuthClient()
    private let keychain = KeychainService.shared
    
    @Published var currentUser: User?
    @Published var isAuthenticated: Bool = false
    
    private init() {
        if keychain.getAccessToken() != nil {
            loadUser()
        }
    }
    
    func login(with response: Auth) {
        currentUser = response.user
        isAuthenticated = true
    }
    
    func logout() {
        Task {
            do {
                try await authClient.logout()
            } catch {
                print("Logout error: \(error)")
            }
            
            await MainActor.run {
                currentUser = nil
                isAuthenticated = false
            }
        }
    }
    
    private func loadUser() {
        Task {
            do {
                let response = try await authClient.refreshToken()
                await MainActor.run {
                    currentUser = response.user
                    isAuthenticated = true
                }
            } catch {
                await MainActor.run {
                    currentUser = nil
                    isAuthenticated = false
                }
            }
        }
    }
    
    func getAccessToken() -> String? {
        return authClient.getCurrentAccessToken()
    }
}
