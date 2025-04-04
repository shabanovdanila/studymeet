//
//  Announcement.swift
//  StudyMate
//
//  Created by Данила Шабанов on 25.03.2025.
//

import Foundation

struct Announcement: Codable {
    let id: Int
    let title: String
    let bg_color: String?
    let user_id: Int
    let user_name: String
    let description: String?
    let tags: [Tag]
    let liked: Bool?
}

struct AllAnnouncements: Codable {
    let announces: [Announcement]
}
