//
//  Response.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 05.04.2025.
//

import Foundation

struct Response: Codable, Identifiable {
    let id: Int
    let announcement_id: Int
    let user_id: Int
    let name: String
    let description: String
}

