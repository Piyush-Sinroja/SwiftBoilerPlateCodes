//
//  APIManager+Async.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/30/23.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case serverError(String)
    case decodingError(Error)
    case invalidResponse
    case invalidURL
    case unauthorized
    case postParametersEncodingFalure(description: String)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
            case .badRequest:
                return NSLocalizedString("Unable to perform request", comment: "badRequestError")
            case .serverError(let errorMessage):
                return NSLocalizedString(errorMessage, comment: "serverError")
            case .decodingError:
                return NSLocalizedString("Unable to decode.", comment: "decodingError")
            case .invalidResponse:
                return NSLocalizedString("Invalid response", comment: "invalidResponse")
            case .invalidURL:
                return NSLocalizedString("Invalid URL", comment: "invalidURL")
            case .unauthorized:
                return NSLocalizedString("Unauthorized", comment: "unauthorized")
            case .postParametersEncodingFalure(let description):
                return "APIError - post parameters failure -> \(description)"
        }
    }
}

enum HTTPMethodAsync {
    case get
    case post
    case delete
    
    var name: String {
        switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .delete:
                return "DELETE"
        }
    }
}

struct Resource<T: Codable> {
    let url: URL?
    var method: HTTPMethodAsync = .get
}

struct APIManagerAsync {
    static let shared = APIManagerAsync()
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        
        // add the default header
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        
        // get the token from the Keychain
        let token: String? = "" // Keychain.get("jwttoken")
        
        if let token {
            configuration.httpAdditionalHeaders?["Authorization"] = "Bearer \(token)"
        }
        
        self.session = URLSession(configuration: configuration)
    }
        
    func request<T: Codable>(type: APIEndPointAsync) async throws -> T {
        guard let url = type.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        switch type.method {
            case .get:

            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            
            let queryItems = type.params?.compactMap {
                return URLQueryItem(name: "\($0)", value: "\($1)")
            }
            urlComponents?.queryItems = queryItems
            
            guard let url = urlComponents?.url else {
                throw NetworkError.badRequest

            }
            request = URLRequest(url: url)
            request.httpMethod = type.method.name
                
            case .post:
                do {
                    guard let body = type.body else {
                        throw NetworkError.badRequest
                    }
                    request.httpMethod = type.method.name
                    request.httpBody = try JSONEncoder().encode(body)
                } catch {
                    throw NetworkError.postParametersEncodingFalure(description: "\(error)")
                }
            
            case .delete:
                request.httpMethod = type.method.name
        }

        let (data, response) = try await session.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            switch httpResponse.statusCode {
                case 401:
                    throw NetworkError.unauthorized
                default: break
            }
        }
        
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
