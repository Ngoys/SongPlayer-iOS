import Foundation
import Combine

protocol APIClient {
    var apiBaseURL: URL { get }
    
    func apiRequest(
        _ method: URLRequest.HTTPMethod,
        _ path: String,
        queryItems: [URLQueryItem]?,
        requestHeader: [String: String]?,
        requestBody: Data?,
        requiresAuthorization: Bool) -> AnyPublisher<APIResponse, Error>
}

extension APIClient {
    func apiRequest(
        _ method: URLRequest.HTTPMethod,
        _ path: String,
        queryItems: [URLQueryItem]? = nil,
        requestBody: Data? = nil,
        requestHeader: [String: String]? = nil,
        requiresAuthorization: Bool = false) -> AnyPublisher<APIResponse, Error> {
            return apiRequest(method, path, queryItems: queryItems, requestHeader: requestHeader, requestBody: requestBody, requiresAuthorization: requiresAuthorization)
        }
}
