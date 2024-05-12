//
//  APIEndPoint+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/1/23.
//

import Foundation

enum HTTPMethods {
    case get
    case post
    case delete
    case put
    
    var name: String? {
        switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .delete:
                return "DELETE"
            case .put:
                return "PUT"
        }
    }
}

protocol EndPointType {
    var path: String { get }
    var baseURL: String { get }
    var url: URL? { get }
    var method: HTTPMethods { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
    var params: [String: Any]? { get }
}
