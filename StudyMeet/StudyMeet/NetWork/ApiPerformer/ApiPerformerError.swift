import Foundation

enum ApiPerformerError: Error {
    case badURL
    case badRequest
    case invalidResponse(statusCode: Int)
    case decodeError(Error)
    case networkError(Error)
}
