//
//  ApiTypeConfiguration+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 09/11/23.
//

import Foundation
import Alamofire

extension ApiTypeConfiguration: APIEndPointType {

    // MARK: - Vars & Lets

    var baseURL: String {
        return Constant.API.baseURL
    }

    var url: URL? {
        return URL(string: "\(baseURL)\(path)")
    }

    var apiUrlStr: String {
        switch self {
            case .downloadFile:
                return "https://link.testfile.org/15MB"
            case .getUserCart:
                return "https://fakestoreapi.com/carts"
            case .createTourist:
                return "http://restapi.adequateshop.com/api/Tourist"
            default:
                return "\(baseURL)\(path)"
        }
        //return "\(baseURL)\(path)"
    }

    var version: String {
        return "/v0_1"
    }

    var path: String {
        switch self {
            case .userExists(let email):
                return "/user/check/\(email)"
            case .users:
                return "users"
            case .userId:
                return "users"
            case .downloadFile:
                return ""
            case .getUserCart:
                return ""
            case .createTourist:
                return ""
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
            case .userExists:
                return .post
            case .downloadFile:
                return .get
            case .getUserCart:
                return .get
            case .createTourist:
                return .post
            default:
                return .get
        }
    }

    var headers: HTTPHeaders? {
        return [
            "Content-Type": "application/json"
        ]
    }

    var encoding: ParameterEncoding {
        switch self {
            case .downloadFile:
                return URLEncoding.default
            case .getUserCart:
                return URLEncoding.default
            default:
                return JSONEncoding.default
        }
    }
}
