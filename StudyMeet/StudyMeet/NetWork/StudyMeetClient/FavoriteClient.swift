//
//  FavoriteClient.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 04.04.2025.
//

import Foundation

struct FavoriteClient {
    
    private let requestHandler = RequestHandler()
    
    func createFavorites(announcement_id: Int) async throws {
        try await requestHandler.post(path: "/favorites", body: announcement_id)
    }
    
    func getFavoritesByUserId(user_id: Int, limit: String, page: String) async throws -> AllAnnouncements {
        return try await requestHandler.get(path: "/favorites/user/\(user_id)", query: ["limit" : limit, "page": page])
    }
    
    func deleteFavoriteById(favorite_id: Int) async throws {
        try await requestHandler.delete(path: "/favorites/\(favorite_id)")
    }
    
}

