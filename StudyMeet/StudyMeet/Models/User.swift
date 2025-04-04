import Foundation

struct User: Codable {
    let id: Int
    let email: String
    let password: String
    let name: String
    let username: String
    let description: String?
    let location: String?
    let gender: Bool?
    let birthday: String?
    let created_at: String
}

