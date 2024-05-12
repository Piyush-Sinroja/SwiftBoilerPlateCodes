//
//  APIManager.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 10/31/23.
//

import Foundation
import Network
import UIKit
import Reachability

public enum DataError: Error, LocalizedError {
    case invalidResponse
    case invalidURL
    case badRequest
    case invalidData
    case timeOut
    case InternetConnectionNotAvailable
    case decoding(Error)
    case somethingwentwrong

    public var description: String {
        switch self {
        case .invalidResponse:
            return "InvalidResponse"
        case .invalidURL:
            return "InvalidURL"
        case .badRequest:
            return "BadRequest"
        case .invalidData:
            return "InvalidData"
        case .timeOut:
            return "TimeOut"
        case .InternetConnectionNotAvailable:
            return "Internet Connection not available"
        case .decoding(let error):
            return "Decoding Error: \(error.localizedDescription)"
        case .somethingwentwrong:
            return "Some Thing Went Wrong"
        }
    
    }
}

typealias ResultHandler<T> = (Result<T, DataError>) -> Void

final class APIManager {
    static let shared = APIManager()
    private let networkHandler: NetworkHandler
    private let responseHandler: ResponseHandler

    init(networkHandler: NetworkHandler = NetworkHandler(), responseHandler: ResponseHandler = ResponseHandler()) {
        self.networkHandler = networkHandler
        self.responseHandler = responseHandler
    }

    func request<T: Codable>(modelType: T.Type, type: EndPointType, completion: @escaping ResultHandler<T>) {
        
        guard NetowrkReachability.shared.isInternetAvailable == true else {
            completion(.failure(.InternetConnectionNotAvailable))
            return
        }
        
        guard let url = type.url else {
            completion(.failure(.invalidURL))
            return
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
                completion(.failure(.badRequest))
                return
            }
                        
            request.httpMethod = type.method.name
            request = URLRequest(url: url)
            
            case .post:
                request.httpMethod = type.method.name            
                do {
                    guard let body = type.body else {
                        throw NetworkError.badRequest
                    }
                    request.httpMethod = type.method.name
                    request.httpBody = try JSONEncoder().encode(body)
                } catch {
                    completion(.failure(.invalidData))
                }
            case .delete, .put:
                request.httpMethod = type.method.name
        
        }

        request.allHTTPHeaderFields = type.headers

        networkHandler.requestDataAPI(url: request) { result in
            switch result {
            case .success(let data):
                self.responseHandler.parseResonseDecode(data: data, modelType: modelType) { response in
                    switch response {
                    case .success(let mainResponse):
                        completion(.success(mainResponse))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    static var commonHeaders: [String: String] {
        return [
            "Content-Type": "application/json"
        ]
    }
}

class NetworkHandler {
    func requestDataAPI(url: URLRequest, completionHandler: @escaping (Result<Data, DataError>) -> Void) {
        let session = URLSession.shared.dataTask(with: url) { data, response, error in

            guard data != nil else {
                completionHandler(.failure(.timeOut))
                return
            }

            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode
            else {
                completionHandler(.failure(.invalidResponse))
                return
            }

            guard let data, error == nil else {
                completionHandler(.failure(.invalidData))
                return
            }

            completionHandler(.success(data))
        }
        session.resume()
    }
}

class ResponseHandler {
    func parseResonseDecode<T: Decodable>(data: Data, modelType: T.Type, completionHandler: ResultHandler<T>) {
        do {
            let userResponse = try JSONDecoder().decode(modelType, from: data)
            completionHandler(.success(userResponse))
        } catch {
            completionHandler(.failure(.decoding(error)))
        }
    }
}

// USING Async Await
extension APIManager {

    func request<T: Codable>(type: EndPointTypeAsync) async throws -> T {
        
        guard NetowrkReachability.shared.isInternetAvailable == true else {            
            throw DataError.InternetConnectionNotAvailable
        }
        
        guard let url = type.url else {
            throw DataError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw DataError.invalidResponse
        }
        
        do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        } catch {
            throw DataError.decoding(error)
        }
    }
}
