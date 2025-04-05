//
//  ResponseClient .swift
//  StudyMeet
//
//  Created by Данила Шабанов on 05.04.2025.
//

import Foundation

final class TagClient {
    
    private let requestHandler = RequestHandler()
    
    func createTag(name: String, color: String) async throws {
        
        let request = CreateTagRequest(name: name, color: color)
        
        try await requestHandler.post(path: "/tag", body: request)
    }
    
    func getAllTags() async throws -> AllTag {
        return try await requestHandler.get(path: "/tag")
    }
    
    func getTagById(tag_id: Int) async throws -> Tag {
        return try await requestHandler.get(path: "/tag/\(tag_id)")
    }
    
    func deleteTagById(tag_id: Int) async throws {
        try await requestHandler.delete(path: "/tag/\(tag_id)")
    }
    
}

private extension TagClient {
    
    struct CreateTagRequest: Encodable {
        let name: String
        let color: String
    }
    
}
