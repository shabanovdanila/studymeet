//
//  ResponseClient .swift
//  StudyMeet
//
//  Created by Данила Шабанов on 05.04.2025.
//

import Foundation

final class ResponseClient {
    
    private let requestHandler = RequestHandler()
    
    func createResponse(description: String, announcement_id: Int) async throws {
        
        let request = CreateResponseRequest(description: description, announcement_id: announcement_id)
        try await requestHandler.post(path: "/response", body: request)
    }
    
    func getAllResponses() async throws -> AllResponse {
        return try await requestHandler.get(path: "/response")
    }
    
    func getResponseById(response_id: Int) async throws -> Response {
        return try await requestHandler.get(path: "/response/\(response_id)")
    }
    
    func getResponseByAnnounceId(announce_id: Int) async throws -> AllResponse {
        return try await requestHandler.get(path: "/response/\(announce_id)")
    }
    
    func getResponseByUserId(user_id: Int) async throws -> AllResponse {
        return try await requestHandler.get(path: "/response/\(user_id)")
    }
    
    func deleteResponseById(response_id: Int) async throws {
        try await requestHandler.delete(path: "/response/\(response_id)")
    }
    
}

private extension ResponseClient {
    
    struct CreateResponseRequest: Encodable {
        let description: String
        let announcement_id: Int
    }
    
}
