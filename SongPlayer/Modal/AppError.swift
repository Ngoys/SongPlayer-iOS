import Foundation

enum AppError: Error {
    case invalidData
    case urlError
    case network

    // HTTP Status Code 400 range.
    case authentication
    case badRequest
    case notFound
    case invalidateSession

    // HTTP Status code 500 range.
    case serverError
}
