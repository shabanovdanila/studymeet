//
//  FavoriteClient.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 04.04.2025.
//

import Foundation

final class FavoriteClient {
    
    private let requestHandler: RequestHandler
        
    init(requestHandler: RequestHandler) {
        self.requestHandler = requestHandler
    }
    
    func createFavorites(announcement_id: Int) async throws {
        let request = FavoriteRequest(announcement_id: announcement_id)
        try await requestHandler.post(path: "/favorites", body: request, query: nil, headers: nil)
    }
    
    func getFavoritesByUserId(limit: String, page: String) async throws -> [Announcement] {
        return try await requestHandler.get(path: "/favorites/user", query: ["limit" : limit, "page": page], headers: nil)
    }
    
    func deleteFavoriteById(favorite_id: Int) async throws {
        try await requestHandler.delete(path: "/favorites/\(favorite_id)", body: nil, query: nil, headers: nil)
    }
}

private extension FavoriteClient {
    struct FavoriteRequest: Encodable {
        let announcement_id: Int
    }
}
