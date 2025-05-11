import Foundation

final class RequestHandlerDefault: RequestHandler {
    
    private let apiPeformer: ApiPerformer
    
    init(apiPerformer: ApiPerformer) {
        self.apiPeformer = apiPerformer
    }
    
    // MARK: - GET
    func get<T: Decodable>(path: String? = nil, query: [String: String?]? = nil, headers: [String: String]? = nil) async throws -> T {
        try await apiPeformer.performRequest(method: "GET", path: path, query: query, body: nil, headers: headers)
    }
    
    // MARK: - POST
    func post<T: Decodable>(path: String? = nil, body: Encodable? = nil, query: [String: String?]? = nil, headers: [String: String]? = nil) async throws -> T {
        try await apiPeformer.performRequest(method: "POST", path: path, query: query, body: body, headers: headers)
    }
    
    func post(path: String? = nil, body: Encodable? = nil, query: [String: String?]? = nil, headers: [String: String]? = nil) async throws {
        try await apiPeformer.performRequest(method: "POST", path: path, query: query, body: body, headers: headers)
    }
    
    // MARK: - PUT
    func put<T: Decodable>(path: String? = nil, body: Encodable? = nil, query: [String: String?]? = nil, headers: [String: String]? = nil) async throws -> T {
        try await apiPeformer.performRequest(method: "PUT", path: path, query: query, body: body, headers: headers)
    }
    
    func put(path: String? = nil, body: Encodable? = nil, query: [String: String?]? = nil, headers: [String: String]? = nil) async throws {
        try await apiPeformer.performRequest(method: "PUT", path: path, query: query, body: body, headers: headers)
    }
    
    // MARK: - DELETE
    func delete<T: Decodable>(path: String? = nil, body: Encodable? = nil, query: [String: String?]? = nil, headers: [String: String]? = nil) async throws -> T {
        try await apiPeformer.performRequest(method: "DELETE", path: path, query: query, body: body, headers: headers)
    }
    
    func delete(path: String? = nil, body: Encodable? = nil, query: [String: String?]? = nil, headers: [String: String]? = nil) async throws {
        try await apiPeformer.performRequest(method: "DELETE", path: path, query: query, body: body, headers: headers)
    }
}

