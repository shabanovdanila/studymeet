//
//  AnnouncClient.swift
//  StudyMate
//
//  Created by Данила Шабанов on 25.03.2025.
//

import Foundation
struct AnnouncClient {
    
    private let requestHandler = RequestHandler(baseURL: "https://studymate-backend-k56p.onrender.com/api")
    
//    func getAllAnnouncements(limit: Int, page: Int) async throws -> AllAnnouncements {
//        //return try await requestHandler.fetchData(components: "?limit=\(limit)&page=\(page)")
//    }
    
    func getShortAnnouncementById(id: Int) async throws -> Announcement {
        return try await requestHandler.get(path: "/short-info/\(id)")
    }
//    
//    func getFullAnnouncementById(id: Int) async throws -> Announcement {
//        //return try await requestHandler.fetchData(components: "/full-info/\(id)")
//    }
//    
//    
//    func getAllAnnouncementsByUserId(user_id: Int, limit: Int, page: Int) async throws -> AllAnnouncements {
//        //return try await requestHandler.fetchData(components: "/user/\(user_id)?limit=\(limit)&page=\(page)")
//    }
}
