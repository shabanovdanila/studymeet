//
//  ChatPreview.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 04.07.2025.
//

import Foundation

struct Chat: Codable {
    let id: Int
    let name: String
    let users: [ChatUser]
    //let messages: [ChatMessage]
    let last_message: ChatLastMessage
    let chat_settings: ChatSettings
    
    struct ChatUser: Codable {
        let id: Int
        let name: String
        let username: String
    }
    struct ChatLastMessage: Identifiable, Codable {
        let id: Int
        let content: String
        let user_id: Int
        let username: String
        let created_at: String
    }
}

struct ChatSettings: Codable {
    let id: Int
    let muted: Bool
    let notifications: Bool
}
