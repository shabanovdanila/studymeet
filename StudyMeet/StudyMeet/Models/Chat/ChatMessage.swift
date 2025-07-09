//
//  ChatMessage.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 04.07.2025.
//

import Foundation

struct ChatMessage: Codable, Identifiable {
    let id: Int
    let content: String
    let user_id: Int
    let username: String
    let chat_id: Int
    let answered_message: ChatShortMessage?
    let created_at: String
    let updated_at: String?
    let deleted_at: String?
    
    struct ChatShortMessage: Codable {
        let id: Int
        let username: String
        let content: String
        let user_id: Int
        let created_at: String
    }
}

struct FullChat: Codable {
    let id: Int
    let name: String
    let users: [ChatUser]
    let messages: [ChatMessage]
    let last_message: ChatLastMessage?
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
