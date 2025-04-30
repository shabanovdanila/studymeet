//
//  AnnouncClient.swift
//  StudyMate
//
//  Created by Данила Шабанов on 25.03.2025.
//

import Foundation

final class AnnouncClient {
    
    private let requestHandler = RequestHandler()
    
    func createAnnouncement(title: String, description: String?,
                            tags: [(name: String, color: String)]) async throws {
        
        let tagRequests = tags.map { TagRequest(name: $0.name, color: $0.color) }
        
        let request = CreateAnnouncementRequest(announcement: AnnouncementRequest(title: title, description: description), tags: tagRequests)
        
        try await requestHandler.post(path: "/announcement", body: request)
    }
    
    func getAllAnnouncements(limit: String, page: String, tags: [String]? = nil, gender: String? = nil, min_age: String? = nil, max_age: String? = nil) async throws -> [Announcement] {
        
        //let tagsToSend = tags != nil ? tags?.compactMap{$0}.joined(separator: ";") : nil
        
        let data: [Announcement] = try await requestHandler.get(path: "/announcement", query: ["limit": limit, "page": page])
        print(data)
        return data
    }
    
    func getShortAnnouncementById(id: Int) async throws -> Announcement {
        try await requestHandler.get(path: "/announcement/short-info/\(id)")
    }
    
    func getFullAnnouncementById(id: Int) async throws -> Announcement {
        try await requestHandler.get(path: "/announcement/full-info/\(id)")
    }
    
    func getAllAnnouncementsByUserId(userId: Int, limit: String, page: String) async throws -> [Announcement] {
        return try await requestHandler.get(path: "/announcement/user/\(userId)", query: ["limit" : limit, "page": page])
    }
    
    func updateAnnouncementById(id: Int, title: String, description: String, tags: [(name: String, color: String)]) async throws {
        
        let request = UpdateAnnouncementRequest(title: title, description: description, tags: tags.map{TagRequest(name: $0.name, color: $0.color)})
        
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
        let tags: [TagRequest]
    }
    
    struct CreateAnnouncementRequest: Encodable {
        let announcement: AnnouncementRequest
        let tags: [TagRequest]
    }

    struct AnnouncementRequest: Encodable {
        let title: String
        let description: String?
    }
    
    struct TagRequest: Encodable {
        let name: String
        let color: String
    }
}
