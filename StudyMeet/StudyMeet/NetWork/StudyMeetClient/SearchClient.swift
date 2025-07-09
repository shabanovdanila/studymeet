//
//  SearchClient.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 14.06.2025.
//

import Foundation

final class SearchClient {
    
    private let requestHandler: RequestHandler
    
    init(requestHandler: RequestHandler) {
        self.requestHandler = requestHandler
    }

    func getAllAnnouncements(limit: String, page: String, tags: [String]? = nil, gender: String? = nil, min_age: String? = nil, max_age: String? = nil) async throws -> [Announcement] {
        let data: [Announcement] = try await requestHandler.get(path: "/announcement", query: ["limit": limit, "page": page], headers: nil)
        return data
    }
    
    func searchBy() {}
    
    func searchByUserName(user_name: String) {}
    
    func searchByTitle(title: String) {}
    
    func searchByTags(tags: [String]) {}
}
