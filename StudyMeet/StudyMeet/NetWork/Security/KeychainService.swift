//
//  KeychainService.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 20.04.2025.
//

import Security
import Foundation

final class KeychainService {
    static let shared = KeychainService()
    private init() {}
    
    private let authServiceName = "com.studymeet.auth"
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    
    func saveTokens(accessToken: String, refreshToken: String) -> Bool {
        let accessTokenSaved = save(key: accessTokenKey, data: accessToken)
        let refreshTokenSaved = save(key: refreshTokenKey, data: refreshToken)
        return accessTokenSaved && refreshTokenSaved
    }
    
    func getAccessToken() -> String? {
        return load(key: accessTokenKey)
    }
    
    func getRefreshToken() -> String? {
        return load(key: refreshTokenKey)
    }
    
    func clearTokens() -> Bool {
        let accessDeleted = delete(key: accessTokenKey)
        let refreshDeleted = delete(key: refreshTokenKey)
        return accessDeleted && refreshDeleted
    }
    
    private func save(key: String, data: String) -> Bool {
        guard let data = data.data(using: .utf8) else { return false }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: authServiceName,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }
    
    private func load(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: authServiceName,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    private func delete(key: String) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: authServiceName,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        return status == errSecSuccess
    }
}
