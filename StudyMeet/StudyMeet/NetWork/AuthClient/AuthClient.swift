//
//  AuthClient.swift
//  StudyMate
//
//  Created by Данила Шабанов on 03.04.2025.
//

import Foundation

final class AuthClient {
    
    private let requestHandler: RequestHandler
    
    private let keychain = KeychainService.shared
    
    init(requestHandler: RequestHandler) {
        self.requestHandler = requestHandler
    }
    
    
    func register(email: String, password: String, name: String, username: String) async throws -> Auth {
        
        let request = RegistrationRequest(email: email, password: password, name: name, user_name: username)
        
        let response: Auth =  try await requestHandler.post(path: "/auth/registration", body: request, query: nil, headers: nil)
        
        if !keychain.saveTokens(accessToken: response.access_token, refreshToken: response.refresh_token) {
            throw AuthError.tokenSaveFailed
        }
        return response
    }
    
    func login(email: String, password: String) async throws -> Auth {
        let request = LoginRequest(email: email, password: password)
        let response: Auth = try await requestHandler.post(path: "/auth/login", body: request, query: nil, headers: nil)
        
        if !keychain.saveTokens(accessToken: response.access_token, refreshToken: response.refresh_token) {
            throw AuthError.tokenSaveFailed
        }
        return response
    }
    
    
    func refreshToken() async throws -> Auth {
        guard let refreshToken = keychain.getRefreshToken() else {
            throw AuthError.noRefreshToken
        }
        
        let response: Auth = try await requestHandler.post(path: "/auth/refresh", body: ["refresh_token": refreshToken], query: nil, headers: nil)
        
        if !keychain.saveTokens(accessToken: response.access_token, refreshToken: response.refresh_token) {
            throw AuthError.tokenSaveFailed
        }
        
        return response
    }
    
    func logout() async throws {
        guard let refreshToken = keychain.getRefreshToken() else {
            keychain.clearTokens()
            return
        }
        
        do {
            _ = try await requestHandler.post(path: "/auth/logout", body: nil, query: nil, headers: nil)
        } catch {
            print("Logout error: \(error)")
        }
        
        keychain.clearTokens()
    }
    
}

private extension AuthClient {
    
    struct RegistrationRequest: Codable {
        let email: String
        let password: String
        let name: String
        let user_name: String
    }

    struct LoginRequest: Codable {
        let email: String
        let password: String
    }
}
