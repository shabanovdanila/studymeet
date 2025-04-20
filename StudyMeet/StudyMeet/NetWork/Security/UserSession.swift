//
//  UserSession.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 20.04.2025.
//

import Foundation

final class UserSession: ObservableObject {
    
    static let shared = UserSession()
    
    @Published var isAuthenticated: Bool = false
    
    private init() {}
    
    func login() {
        isAuthenticated = true
    }
        
    func logout() {
        isAuthenticated = false
    }
}
