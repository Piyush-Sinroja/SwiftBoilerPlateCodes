//
//  UserCart.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 04/12/23.
//

import Foundation

struct UserCart: Codable {

    let version: Int?
    let date: String?
    let id: Int?
    let products: [Product]?
    let userId: Int?

    enum CodingKeys: String, CodingKey {
        case version = "__v"
        case date = "date"
        case id = "id"
        case products = "products"
        case userId = "userId"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        version = try values.decodeIfPresent(Int.self, forKey: .version)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        products = try values.decodeIfPresent([Product].self, forKey: .products)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
    }
}

struct Product: Codable {

    let productId: Int?
    let quantity: Int?

    enum CodingKeys: String, CodingKey {
        case productId = "productId"
        case quantity = "quantity"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        productId = try values.decodeIfPresent(Int.self, forKey: .productId)
        quantity = try values.decodeIfPresent(Int.self, forKey: .quantity)
    }
}

// codable reference: https://blog.logrocket.com/simplify-json-parsing-swift-using-codable/#array-example
