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
    }
    
    func login(user: User) {
        self.currentUser = user
        self.isAuthenticated = true
        try? keychain.saveUser(user)
        ChatSocketService.shared.connect(token: keychain.getAccessToken() ?? nil)
    }
    
    func updateUser(name: String? = nil, location: String? = nil, gender: Bool? = nil, birtday: String? = nil, description: String? = nil, created_at: String? = nil) {
        if let currentUser = self.currentUser {
            let newUser = User(id: currentUser.id, email: currentUser.email, name: name ?? currentUser.name, user_name: currentUser.user_name, description: description ?? currentUser.description, location: location ?? currentUser.location, gender: gender ?? currentUser.gender, birthday: birtday ?? currentUser.birthday, created_at: created_at ?? currentUser.created_at)
            login(user: newUser)
        }
    }
    
    func logout() {
        self.currentUser = nil
        self.isAuthenticated = false
        try? keychain.deleteUser()
    }
    
    private func loadUserFromKeychain() {
        if let savedUser = try? keychain.getUser() {
            self.currentUser = savedUser
            self.isAuthenticated = true
            print("succes load from keychain")
        }
    }
}
