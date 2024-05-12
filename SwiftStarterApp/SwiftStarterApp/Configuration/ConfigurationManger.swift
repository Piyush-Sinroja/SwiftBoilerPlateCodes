//
//  ConfigurationManger.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 10/31/23.
//

import Foundation

enum ConfigurationManger {
    enum Enviornment {
        case dev
        case stage
        case prod
    }

    static var enviornment: Enviornment {
        #if DEV
            return .dev
        #elseif STAGE
            return .stage
        #elseif PROD
            return .prod
        #endif
    }
}

enum BuildConfiguration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }

    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }
        switch object {
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

enum API {
    static var baseUrl: String {
        do {
            return try BuildConfiguration.value(for: "BASE_URL")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
