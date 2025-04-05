//
//  Response.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 05.04.2025.
//

import Foundation

struct Response: Codable {
    let id: Int
    let announcement_id: Int
    let user_id: Int
    let user_name: String
    let descritption: String
}

struct AllResponse: Codable {
    let responses: [AllResponse]
}
