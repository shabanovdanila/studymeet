//
//  ResponseClient .swift
//  StudyMeet
//
//  Created by Данила Шабанов on 05.04.2025.
//

import Foundation

final class ResponseClient {
    
    private let requestHandler: RequestHandler
        
    init(requestHandler: RequestHandler) {
        self.requestHandler = requestHandler
    }
    
    func createResponse(description: String, announcement_id: Int) async throws {
        let request = CreateResponseRequest(description: description, announcement_id: announcement_id)
        try await requestHandler.post(path: "/response", body: request, query: nil, headers: nil)
    }
    
    func getAllResponses() async throws -> AllResponse {
        return try await requestHandler.get(path: "/response", query: nil, headers: nil)
    }
    
    func getResponseById(response_id: Int) async throws -> Response {
        return try await requestHandler.get(path: "/response/\(response_id)", query: nil, headers: nil)
    }
    
    func getResponseByAnnounceId(announce_id: Int) async throws -> AllResponse {
        return try await requestHandler.get(path: "/response/\(announce_id)", query: nil, headers: nil)
    }
    
    func getResponseByUserId(user_id: Int) async throws -> AllResponse {
        return try await requestHandler.get(path: "/response/\(user_id)", query: nil, headers: nil)
    }
    
    func deleteResponseById(response_id: Int) async throws {
        try await requestHandler.delete(path: "/response/\(response_id)", body: nil, query: nil, headers: nil)
    }
    
}

private extension ResponseClient {
    
    struct CreateResponseRequest: Encodable {
        let description: String
        let announcement_id: Int
    }
    
}
