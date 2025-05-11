//
//  UserSession.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 20.04.2025.
//

import Foundation

final class UserSession: ObservableObject {
    
    static let shared = UserSession()
    private let keychain = KeychainService.shared
    
    @Published private(set) var isAuthenticated: Bool = false
    @Published private(set) var currentUser: User?
    
    private init() {
        self.loadUserFromKeychain()
        print(currentUser?.name)
    }
    
    func login(user: User) {
        self.currentUser = user
        self.isAuthenticated = true
        try? keychain.saveUser(user)
    }
    
    func logout() {
        self.currentUser = nil
        self.isAuthenticated = false
        try? keychain.deleteUser()
    }
    
    private func loadUserFromKeychain() {
        if let savedUser = try? keychain.getUser() {
            self.currentUser = savedUser
            print("email:")
            print(currentUser?.email)
            self.isAuthenticated = true
        }
    }
}
