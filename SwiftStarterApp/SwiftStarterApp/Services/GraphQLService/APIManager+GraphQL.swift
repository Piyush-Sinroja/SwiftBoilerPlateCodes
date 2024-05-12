//
//  GraphQLNetworkService.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 1/2/24.
//

import Apollo
import Foundation

final class APIManagerGraphQL {
    
    static let shared = APIManagerGraphQL()
    
    private(set) var apollo = ApolloClient(url: URL(string: "https://spacex-production.up.railway.app/")!)
    
    private init() { }
}
