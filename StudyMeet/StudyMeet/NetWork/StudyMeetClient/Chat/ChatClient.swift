//
//  ChatClient.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 04.07.2025.
//

import Foundation

final class ChatClient {
    
    private let requestHandler: RequestHandler
    
    init(requestHandler: RequestHandler) {
        self.requestHandler = requestHandler
    }

    func updateChatSettingsById(id: Int, muted: Bool, notifications: Bool) async throws -> ChatSettings {
        try await requestHandler.put(path: "/chat/\(id)/settings", body: ChatSettingsRequest(muted: muted, notifications: notifications), query: nil, headers: nil)
    }
    
    func deleteChatById(id: Int) async throws {
        try await requestHandler.delete(path: "chat/\(id)", body: nil, query: nil, headers: nil)
    }
    
    func getAllUserChats(limit: String, page: String) async throws -> [Chat] {
        try await requestHandler.get(path: "/chat/user", query: ["limit": limit, "page": page], headers: nil)
    }
    
    func getInfoChatById(id: Int, limit: String, page: String) async throws -> FullChat {
        try await requestHandler.get(path: "/chat/\(id)", query: ["limit": limit, "page": page], headers: nil)
    }
}

private extension ChatClient {
    struct ChatSettingsRequest: Encodable {
        let muted: Bool
        let notifications: Bool
    }
}
