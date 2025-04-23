import Foundation

enum ApiPerformerError: Error {
    case badURL
    case invalidResponse(statusCode: Int)
    case httpError(statusCode: Int)
    case decodeError(Error)
    case noInternetConnection
    case timeout
    case networkError(Error)
    case unauthorized
    case tokenSavingFailed
    case tooManyRequests
}
