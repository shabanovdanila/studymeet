import Foundation

final class UserClient {
    
    private let requestHandler = RequestHandler()
    

    func getUserById(id: Int) async throws -> User {
        try await requestHandler.get(path: "/user/\(id)")
    }
    func updateUser(name: String? = nil, location: String? = nil, gender: String? = nil, birthday: String? = nil, description: String? = nil) async throws {
        let request = UpdateUserRequest(name: name, location: location, gender: gender, birthday: birthday, description: description)
        try await requestHandler.put(path: "/user", body: request)
    }
    
}

private extension UserClient {
    struct UpdateUserRequest: Encodable {
        let name: String?
        let location: String?
        let gender: String?
        let birthday: String?
        let description: String?
    }
}
