import Foundation


final class ApiPerformer: ApiPerformerProtocol {
    
    private let baseURL: String
    private let urlSession: URLSession
    
    init(baseURL: String, urlSession: URLSession = .shared) {
        self.baseURL = baseURL
        self.urlSession = urlSession
    }
    
    func performRequest<T: Decodable>(method: String, path: String, query: [String: String?]? = nil, body: Encodable? = nil, headers: [String: String]? = nil) async throws -> T {
        
        let request = try makeRequest(method: method, path: path, query: query, body: body, headers: headers)
        
        let (data, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiPerformerError.invalidResponse(statusCode: 0)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw ApiPerformerError.invalidResponse(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ApiPerformerError.decodeError(error)
        }
    }
    
    func performRequest(method: String, path: String, query: [String: String?]? = nil, body: Encodable? = nil, headers: [String: String]? = nil) async throws {
        
        let request = try makeRequest(method: method, path: path, query: query, body: body, headers: headers)
        
        let (_, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiPerformerError.invalidResponse(statusCode: 0)
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw ApiPerformerError.invalidResponse(statusCode: httpResponse.statusCode)
        }
    }
    
    
    private func makeRequest(method: String, path: String, query: [String: String?]?, body: Encodable?, headers: [String: String]?) throws -> URLRequest {
        
        guard var urlComponents = URLComponents(string: baseURL + path) else {
            throw ApiPerformerError.badURL
        }
        
        if let query = query {
            urlComponents.queryItems = query.compactMap { key, value in
                guard let value = value else { return nil }
                return URLQueryItem(name: key, value: value)
            }
        }
        
        guard let url = urlComponents.url else {
            throw ApiPerformerError.badURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let body = body {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        return request
    }
}
