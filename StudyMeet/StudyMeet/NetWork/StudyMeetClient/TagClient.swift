//
//  ResponseClient .swift
//  StudyMeet
//
//  Created by Данила Шабанов on 05.04.2025.
//

import Foundation

final class TagClient {
    
    private let requestHandler: RequestHandler
        
    init(requestHandler: RequestHandler) {
        self.requestHandler = requestHandler
    }
    
    func createTag(name: String, color: String) async throws {
        
        let request = CreateTagRequest(name: name, color: color)
        
        try await requestHandler.post(path: "/tag", body: request, query: nil, headers: nil)
    }
    
    func getAllTags() async throws -> [Tag] {
        return try await requestHandler.get(path: "/tag", query: nil, headers: nil)
    }
    
    func getTagById(tag_id: Int) async throws -> Tag {
        return try await requestHandler.get(path: "/tag/\(tag_id)", query: nil, headers: nil)
    }
    
    func deleteTagById(tag_id: Int) async throws {
        try await requestHandler.delete(path: "/tag/\(tag_id)", body: nil, query: nil, headers: nil)
    }
    
}

private extension TagClient {
    
    struct CreateTagRequest: Encodable {
        let name: String
        let color: String
    }
    
}
