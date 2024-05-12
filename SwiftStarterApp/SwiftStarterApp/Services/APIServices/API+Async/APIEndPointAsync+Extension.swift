//
//  APIEndPoint+Extension+Async.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 12/4/23.
//

import Foundation

protocol EndPointTypeAsync {
    var path: String { get }
    var baseURL: String { get }
    var url: URL? { get }
    var method: HTTPMethodAsync { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
    var params: [String: Any]? { get }
}
