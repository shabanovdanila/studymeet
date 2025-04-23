import Foundation


final class ApiPerformer: ApiPerformerProtocol {
    
    private let baseURL: String
    private let urlSession: URLSession
    private let keychainService: KeychainService
    
    init(baseURL: String, urlSession: URLSession = .shared, keychainService: KeychainService = .shared) {
        self.baseURL = baseURL
        self.urlSession = urlSession
        self.keychainService = keychainService
    }
    
    // MARK: - Token Refresh
    private func refreshToken() async throws {
        guard let refreshToken = keychainService.getRefreshToken() else {
            throw ApiPerformerError.unauthorized
        }
        
        let refreshRequest = try makeRequest(
            method: "POST",
            path: "/auth/refresh", query: nil,
            body: ["refresh_token": refreshToken],
            headers: nil
        )
        
        let (data, _) = try await urlSession.data(for: refreshRequest)
        let token = try JSONDecoder().decode(Auth.self, from: data)
        
        if !keychainService.saveTokens(accessToken: token.access_token, refreshToken: token.refresh_token) {
            throw ApiPerformerError.tokenSavingFailed
        }
    }
    
    // MARK: - Request with T
    func performRequest<T: Decodable>(method: String, path: String? = nil, query: [String: String?]? = nil, body: Encodable? = nil, headers: [String: String]? = nil) async throws -> T {
        
        let request = try await makeAuthenticatedRequest(method: method, path: path, query: query, body: body, headers: headers)
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ApiPerformerError.invalidResponse(statusCode: 0)
            }
            
            switch httpResponse.statusCode {
            case 200..<300:
                return try JSONDecoder().decode(T.self, from: data)
            case 429:
                throw ApiPerformerError.tooManyRequests
            case 401:
                try await refreshToken()
                let newRequest = try await makeAuthenticatedRequest(method: method, path: path, query: query, body: body, headers: headers)
                let (newData, newResponse) = try await urlSession.data(for: newRequest)
                
                guard let newHttpResponse = newResponse as? HTTPURLResponse,
                      (200..<300).contains(newHttpResponse.statusCode) else {
                    throw ApiPerformerError.invalidResponse(statusCode: (newResponse as? HTTPURLResponse)?.statusCode ?? 0)
                }
                
                return try JSONDecoder().decode(T.self, from: newData)
            default:
                throw ApiPerformerError.invalidResponse(statusCode: httpResponse.statusCode)
            }
        } catch {
            throw error
        }
    }
    
    // MARK: - Empty Request
    func performRequest(method: String, path: String? = nil, query: [String: String?]? = nil, body: Encodable? = nil, headers: [String: String]? = nil) async throws {
        
        let request = try await makeAuthenticatedRequest(method: method, path: path, query: query, body: body, headers: headers)
        
        let (_, response) = try await urlSession.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ApiPerformerError.invalidResponse(statusCode: 0)
        }
        
        switch httpResponse.statusCode {
        case 200..<300:
            return
        case 429:
            throw ApiPerformerError.tooManyRequests
        case 401:
            try await refreshToken()
            let newRequest = try await makeAuthenticatedRequest(method: method, path: path, query: query, body: body, headers: headers)
            let (_, newResponse) = try await urlSession.data(for: newRequest)
            
            guard let newHttpResponse = newResponse as? HTTPURLResponse,
                  (200..<300).contains(newHttpResponse.statusCode) else {
                throw ApiPerformerError.invalidResponse(statusCode: (newResponse as? HTTPURLResponse)?.statusCode ?? 0)
            }
        default:
            throw ApiPerformerError.invalidResponse(statusCode: httpResponse.statusCode)
        }
    }
    
    // MARK: - Request Construction
    private func makeAuthenticatedRequest(method: String, path: String? = nil, query: [String: String?]? = nil, body: Encodable? = nil, headers: [String: String]? = nil) async throws -> URLRequest {
        var headers = headers ?? [:]
        if let accessToken = keychainService.getAccessToken() {
            headers["Authorization"] = "Bearer \(accessToken)"
        }
        return try makeRequest(method: method, path: path, query: query, body: body, headers: headers)
    }
    
    
    
    private func makeRequest(method: String, path: String?, query: [String: String?]?, body: Encodable?, headers: [String: String]?) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: baseURL + (path ?? "")) else {
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
