//
//  AuthModels.swift
//  StudyMate
//
//  Created by Данила Шабанов on 03.04.2025.
//

import Foundation

struct AuthResponse: Codable {
    let accessToken: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

struct RegistrationData: Codable {
    let email: String
    let password: String
    let name: String
    let username: String
}

struct LoginData: Codable {
    let email: String
    let password: String
}
