//
//  Auth.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 05.04.2025.
//

import Foundation

struct Auth: Codable {
    let user: User?
    let access_token: String
    let refresh_token: String
}

