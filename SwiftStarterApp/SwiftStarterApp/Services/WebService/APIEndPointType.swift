//
//  APIEndPointType.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 09/11/23.
//

import Foundation
import Alamofire

protocol APIEndPointType {
    // MARK: - Vars & Lets

    var baseURL: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var url: URL? { get }
    var encoding: ParameterEncoding { get }
    var version: String { get }

}

enum ApiTypeConfiguration {
    case users // GET
    case userExists(_: String)
    case downloadFile
    case userId(_: String)
    case getUserCart
    case createTourist
}
