import Foundation

struct UserClient {
    
    private let requestHandler = RequestHandler(baseURL: "https://studymate-backend-k56p.onrender.com/api/user/")
    
//    func getUserById(id: Int) async throws -> User {
//        return try await requestHandler.fetchData(components: "\(id)")
//    }
    
}
