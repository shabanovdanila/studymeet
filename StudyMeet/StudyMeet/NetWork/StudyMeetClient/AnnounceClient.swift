//
//  AnnounceClient.swift
//  StudyMate
//
//  Created by Данила Шабанов on 25.03.2025.
//

import Foundation

final class AnnounceClient {
    
    private let requestHandler: RequestHandler
    
    init(requestHandler: RequestHandler) {
        self.requestHandler = requestHandler
    }

    func createAnnouncement(title: String, description: String,
                            tags: [String]) async throws {
        let request = CreateAnnouncementRequest(title: title, description: description,tags: tags)
        
        try await requestHandler.post(path: "/announcement", body: request, query: nil, headers: nil)
    }
    
    func getAllAnnouncements(limit: String, page: String, tags: [String]? = nil, gender: String? = nil, min_age: String? = nil, max_age: String? = nil) async throws -> [Announcement] {
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
        let data: [Announcement] = try await requestHandler.get(path: "/announcement", query: ["limit": limit, "page": page], headers: nil)
        return data
    }
    
    func getShortAnnouncementById(id: Int) async throws -> Announcement {
        try await requestHandler.get(path: "/announcement/short-info/\(id)", query: nil, headers: nil)
    }
    
    func getFullAnnouncementById(id: Int) async throws -> Announcement {
        try await requestHandler.get(path: "/announcement/full-info/\(id)", query: nil, headers: nil)
    }
    
    func getAllAnnouncementsByUserId(userId: Int, limit: String, page: String) async throws -> [Announcement] {
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!1111")
        return try await requestHandler.get(path: "/announcement/user/\(userId)", query: ["limit" : limit, "page": page], headers: nil)
    }
    
    func updateAnnouncementById(id: Int, title: String, description: String, tags: [String]) async throws {
        
        let request = UpdateAnnouncementRequest(title: title, description: description, tags: tags)
        
        try await requestHandler.put(path: "/announcement/\(id)", body: request, query: nil, headers: nil)
    }
    
    func deleteAnnouncementById(id: Int) async throws {
        try await requestHandler.delete(path: "/announcement/\(id)", body: nil, query: nil, headers: nil)
    }
}


private extension AnnounceClient {
    
    struct UpdateAnnouncementRequest: Encodable {
        let title: String
        let description: String
        let tags: [String]
    }
    
    struct CreateAnnouncementRequest: Encodable {
        let title: String
        let description: String
        let tags: [String]
    }

    struct AnnouncementRequest: Encodable {
        let title: String
        let description: String?
    }
    
}
