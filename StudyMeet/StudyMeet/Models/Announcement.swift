//
//  Announcement.swift
//  StudyMate
//
//  Created by Данила Шабанов on 25.03.2025.
//

import Foundation

struct ServerAnnouncement: Codable {
    let announcement: AnnouncementData
    let tags: [Tag]
    
    struct AnnouncementData: Codable {
        let id: Int
        let title: String
        let bg_color: String?
        let user_id: Int
        let user_name: String
        let description: String?
    }
}

struct Announcement: Codable, Identifiable {
    let id: Int
    let title: String
    let bg_color: String?
    let user_id: Int
    let user_name: String
    let description: String?
    let tags: [Tag]
    let liked: Bool?
    
    init(id: Int, title: String, bg_color: String?, user_id: Int, user_name: String, description: String?, tags: [Tag], liked: Bool?) {
        self.id = id
        self.title = title
        self.bg_color = bg_color
        self.user_id = user_id
        self.user_name = user_name
        self.description = description
        self.tags = tags
        self.liked = liked
    }
    
    init(from serverAnnouncement: ServerAnnouncement) {
        self.id = serverAnnouncement.announcement.id
        self.title = serverAnnouncement.announcement.title
        self.bg_color = serverAnnouncement.announcement.bg_color
        self.user_id = serverAnnouncement.announcement.user_id
        self.user_name = serverAnnouncement.announcement.user_name
        self.description = serverAnnouncement.announcement.description
        self.tags = serverAnnouncement.tags
        self.liked = nil
    }
}
