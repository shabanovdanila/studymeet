import Foundation

struct User: Codable {
    let id: Int
    let email: String?
    let name: String
    let user_name: String
    let description: String?
    let location: String?
    let gender: Bool?
    let birthday: String?
    let created_at: String?
}

