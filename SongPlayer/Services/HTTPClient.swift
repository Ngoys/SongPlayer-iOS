import Combine
import Foundation

class HTTPClient {

    //----------------------------------------
    // MARK: - API requests
    //----------------------------------------
    
    func apiRequest(request: URLRequest) -> AnyPublisher<(HTTPURLResponse, Data), Error> {
        return urlSession.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpURLResponse = response as? HTTPURLResponse,
                      (200 ... 299).contains(httpURLResponse.statusCode) else {
                    throw self.handleResponseFailure(data: data,
                                                     response: response)
                }
                
                return (httpURLResponse, data)
            }
            .eraseToAnyPublisher()
    }
    
    //----------------------------------------
    // MARK: - Error handling
    //----------------------------------------
    
    private func handleResponseFailure(data: Data?, response: URLResponse?) -> AppError {
        var error = AppError.badRequest
        
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 401:
                error = .authentication

                do {
                    let apiError = try JSONDecoder().decode(ApiError.self, from: data!)
                    switch apiError.code {

                    default:
                        error = .authentication
                    }
                } catch {
                    break
                }

            default:
                error = .notFound
            }
        }
        
        return error
    }
    
    //----------------------------------------
    // MARK: - Internals
    //----------------------------------------
    
    private lazy var urlSession: URLSession = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 10.0
        sessionConfig.timeoutIntervalForResource = 10.0
        let session = URLSession(configuration: sessionConfig)
        return session
    }()
    
    private var cancellables: Set<AnyCancellable> = Set()
}
