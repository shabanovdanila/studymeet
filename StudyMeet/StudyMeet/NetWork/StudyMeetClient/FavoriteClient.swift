//
//  FavoriteClient.swift
//  StudyMeet
//
//  Created by Данила Шабанов on 04.04.2025.
//

import Foundation

final class FavoriteClient {
    
    private let requestHandler = RequestHandler()
    
    func createFavorites(announcement_id: Int) async throws {
        try await requestHandler.post(path: "/favorites", body: announcement_id)
    }
    
    func getFavoritesByUserId(limit: String, page: String) async throws -> [Announcement] {
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!2222221")
        return try await requestHandler.get(path: "/favorites/user", query: ["limit" : limit, "page": page])
    }
    
    func deleteFavoriteById(favorite_id: Int) async throws {
        try await requestHandler.delete(path: "/favorites/\(favorite_id)")
    }
    
}

