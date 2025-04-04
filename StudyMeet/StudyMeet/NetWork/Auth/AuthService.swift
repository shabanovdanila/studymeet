//
//  AuthService.swift
//  StudyMate
//
//  Created by Данила Шабанов on 03.04.2025.
//

import Foundation

enum AuthError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
    case tokenExpired
}
