//
//  TouristModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 04/12/23.
//

import Foundation

struct TouristModel: Codable {

    var createdat: String?
    var idValue: Int64?
    var touristEmail: String?
    var touristLocation: String?
    var touristName: String?

    enum CodingKeys: String, CodingKey {
        case createdat = "createdat"
        case idValue = "id"
        case touristEmail = "tourist_email"
        case touristLocation = "tourist_location"
        case touristName = "tourist_name"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdat = try values.decodeIfPresent(String.self, forKey: .createdat)
        idValue = try values.decodeIfPresent(Int64.self, forKey: .idValue)
        touristEmail = try values.decodeIfPresent(String.self, forKey: .touristEmail)
        touristLocation = try values.decodeIfPresent(String.self, forKey: .touristLocation)
        touristName = try values.decodeIfPresent(String.self, forKey: .touristName)
    }
}
