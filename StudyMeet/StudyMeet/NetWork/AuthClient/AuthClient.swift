//
//  AuthClient.swift
//  StudyMate
//
//  Created by Данила Шабанов on 03.04.2025.
//

import Foundation

final class AuthClient {
    
    private let requestHandler = RequestHandler()
    
    func register(email: String, password: String, name: String, username: String) async throws -> Auth {
        let request = RegistrationRequest(email: email, password: password, name: name, username: username)
        return try await requestHandler.post(path: "/auth/registration", body: request)
    }
    
    func login(email: String, password: String) async throws -> Auth {
        let request = LoginRequest(email: email, password: password)
        return try await requestHandler.post(path: "/auth/login", body: request)
    }
    
    func refreshToken() async throws -> Auth {
        return try await requestHandler.post(path: "/auth/refresh")
    }
}

private extension AuthClient {
    
    struct RegistrationRequest: Codable {
        let email: String
        let password: String
        let name: String
        let username: String
    }

    struct LoginRequest: Codable {
        let email: String
        let password: String
    }
}
