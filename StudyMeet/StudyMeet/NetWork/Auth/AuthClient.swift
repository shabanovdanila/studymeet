////
////  AuthClient.swift
////  StudyMate
////
////  Created by Данила Шабанов on 03.04.2025.
////
//
//import Foundation
//
//class AuthService {
//    
//    static let shared = AuthService()
//    private init() {}
//    
//    private let baseURL = "http://your-api-base-url.com"
//    private let tokenKey = "authTokens"
//    
//    // MARK: - API Requests
//    
//    func register(registrationData: RegistrationData) async throws -> AuthResponse {
//        let urlString = "\(baseURL)/api/auth/registration"
//        guard let url = URL(string: urlString) else {
//            throw ApiPerformerError.InvalidURL
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        do {
//            request.httpBody = try JSONEncoder().encode(registrationData)
//        } catch {
//            throw ApiPerformerError.DecodeError
//        }
//        
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw ApiPerformerError.NotFound
//        }
//        
//        if httpResponse.statusCode == 401 {
//            throw AuthError.invalidCredentials
//        }
//        
//        guard httpResponse.statusCode == 200 else {
//            throw ApiPerformerError.unauthorized
//        }
//        
//        do {
//            let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
//            saveTokens(authResponse: authResponse)
//            return authResponse
//        } catch {
//            throw ApiPerformerError.DecodeError
//        }
//    }
//    
//    func login(loginData: LoginData) async throws -> AuthResponse {
//        let urlString = "\(baseURL)/api/auth/login"
//        guard let url = URL(string: urlString) else {
//            throw ApiPerformerError.InvalidURL
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        do {
//            request.httpBody = try JSONEncoder().encode(loginData)
//        } catch {
//            throw ApiPerformerError.DecodeError
//        }
//        
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw ApiPerformerError.NotFound
//        }
//        
//        if httpResponse.statusCode == 401 {
//            throw AuthError.invalidCredentials
//        }
//        
//        guard httpResponse.statusCode == 200 else {
//            throw ApiPerformerError.unauthorized
//        }
//        
//        do {
//            let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
//            saveTokens(authResponse: authResponse)
//            return authResponse
//        } catch {
//            throw ApiPerformerError.DecodeError
//        }
//    }
//    
//    func refreshToken() async throws -> AuthResponse {
//        let urlString = "\(baseURL)/api/auth/refresh"
//        guard let url = URL(string: urlString) else {
//            throw ApiPerformerError.InvalidURL
//        }
//        
//        guard let refreshToken = getRefreshToken() else {
//            throw AuthError.tokenExpired
//        }
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
//        
//        let (data, response) = try await URLSession.shared.data(for: request)
//        
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw ApiPerformerError.NotFound
//        }
//        
//        if httpResponse.statusCode == 401 {
//            clearTokens()
//            throw AuthError.tokenExpired
//        }
//        
//        guard httpResponse.statusCode == 200 else {
//            throw ApiPerformerError.unauthorized
//        }
//        
//        do {
//            let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
//            saveTokens(authResponse: authResponse)
//            return authResponse
//        } catch {
//            throw ApiPerformerError.DecodeError
//        }
//    }
//    
//    // MARK: - Token Management
//    
//    private func saveTokens(authResponse: AuthResponse) {
//        UserDefaults.standard.set(authResponse.accessToken, forKey: "accessToken")
//        UserDefaults.standard.set(authResponse.refreshToken, forKey: "refreshToken")
//    }
//    
//    func getAccessToken() -> String? {
//        return UserDefaults.standard.string(forKey: "accessToken")
//    }
//    
//    private func getRefreshToken() -> String? {
//        return UserDefaults.standard.string(forKey: "refreshToken")
//    }
//    
//    func clearTokens() {
//        UserDefaults.standard.removeObject(forKey: "accessToken")
//        UserDefaults.standard.removeObject(forKey: "refreshToken")
//    }
//    
//    func isLoggedIn() -> Bool {
//        return getAccessToken() != nil
//    }
//}
