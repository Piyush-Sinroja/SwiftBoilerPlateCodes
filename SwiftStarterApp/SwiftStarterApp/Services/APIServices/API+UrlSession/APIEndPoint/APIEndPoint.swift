//
//  ProductEndPoint.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 10/31/23.
//

import Foundation

enum APIEndPoint {
    case users // GET
    case usersWithID(params: [String: Any]) // GET WITH URLQueryItem
}

extension APIEndPoint: EndPointType {
        
    var path: String {
        switch self {
        case .users:
            return "users"
        case .usersWithID:
            return "users"
        }
    }

    var baseURL: String {
        switch self {
        case .users:
            return Constant.API.baseURL
        case .usersWithID:
            return Constant.API.baseURL
        }
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }

    var method: HTTPMethods {
        switch self {
        case .users:
            return .get
        case .usersWithID:
            return .get
        }
    }

    var body: Encodable? {
        switch self {
        case .users:
            return nil
        case .usersWithID:
            return nil
        }
    }
    
    var params: [String: Any]? {
        switch self {
        case .users:
            return nil
        case .usersWithID(params: let params):
            return params
        }
    }
    
    var headers: [String: String]? {
        APIManager.commonHeaders
    }
}
