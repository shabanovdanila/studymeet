import Foundation
 

protocol ApiPerformerProtocol {
    
    func performRequest<T: Decodable>(method: String, path: String?, query: [String: String?]?, body: Encodable?,
        headers: [String: String]?) async throws -> T
    
    func performRequest(method: String, path: String?, query: [String: String?]?, body: Encodable?, headers: [String: String]?) async throws
}
