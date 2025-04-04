//
//  AnnouncClient.swift
//  StudyMate
//
//  Created by Данила Шабанов on 25.03.2025.
//

import Foundation

struct AnnouncClient {
    
    private let requestHandler = RequestHandler(baseURL: "https://studymate-backend-k56p.onrender.com/api")
    
    func createAnnouncement(title: String, description: String?, userId: Int, bgColor: String?,
                            tags: [(name: String, color: String)]) async throws {
        
        let tagRequests = tags.map { TagRequest(name: $0.name, color: $0.color) }
        
        let request = CreateAnnouncementRequest(title: title, description: description, user_id: userId, bg_color: bgColor, tags: tagRequests)
        
        try await requestHandler.post(path: "/announcement/", body: request)
    }
    
    func getAllAnnouncements(limit: String, page: String) async throws -> AllAnnouncements {
        return try await requestHandler.get(path: "/announcement", query: ["limit" : limit, "page": page])
    }
    
    func getShortAnnouncementById(id: Int) async throws -> Announcement {
        return try await requestHandler.get(path: "/announcement/short-info/\(id)")
    }
    
    func getFullAnnouncementById(id: Int) async throws -> Announcement {
        return try await requestHandler.get(path: "/announcement/full-info/\(id)")
    }
    
    func getAllAnnouncementsByUserId(userId: Int, limit: String, page: String) async throws -> AllAnnouncements {
        return try await requestHandler.get(path: "/announcement/user/\(userId)", query: ["limit" : limit, "page": page])
    }
    
    func updateAnnouncementById(id: Int, title: String, description: String) async throws {
        let request = UpdateAnnouncementRequest(title: title, description: description)
        try await requestHandler.put(path: "/announcement/\(id)", body: request)
    }
    
    func deleteAnnouncementById(id: Int) async throws {
        try await requestHandler.delete(path: "/announcement/\(id)")
    }
}


private extension AnnouncClient {
    
    struct UpdateAnnouncementRequest: Encodable {
        let title: String
        let description: String
    }
    
    struct CreateAnnouncementRequest: Encodable {
        let title: String
        let description: String?
        let user_id: Int
        let bg_color: String?
        let tags: [TagRequest]
    }

    struct TagRequest: Encodable {
        let name: String
        let color: String
    }
}
