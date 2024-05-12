//
//  StorageService.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 02/11/23.
//

import Foundation

// This class is used to store data to user default and fetch from user default for whole project
class StorageService {
    
    // MARK: - Variables
    
    /// sharing class Preference
    static let shared = StorageService()
    
    ///  interface for interacting with the defaults system
    fileprivate let userdefault = UserDefaults.standard
        
    var preferedLanguage: Language? {
        get { Language(languageCode: UserDefaults.standard.string(forKey: UserDefaultsKeys.language.rawValue)) }
        set { userdefault.set(newValue?.code ?? "", forKey: UserDefaultsKeys.language.rawValue) }
    }

    var isUserConnected: Bool? {
        get { return userdefault.bool(forKey: UserDefaultsKeys.isUserConnected.rawValue) }
        set { userdefault.set(newValue, forKey: UserDefaultsKeys.isUserConnected.rawValue) }
    }
    
    var appLangauge: String? {
        get { return userdefault.string(forKey: UserDefaultsKeys.appLangauge.rawValue) }
        set { userdefault.set(newValue, forKey: UserDefaultsKeys.appLangauge.rawValue) }
    }
    
    var userID: String? {
        get { return userdefault.string(forKey: UserDefaultsKeys.userID.rawValue) }
        set { userdefault.set(newValue, forKey: UserDefaultsKeys.userID.rawValue) }
    }
    
    var userName: String? {
        get { return userdefault.string(forKey: UserDefaultsKeys.userName.rawValue) }
        set { userdefault.set(newValue, forKey: UserDefaultsKeys.userName.rawValue) }
    }

    func set(_ value: Any, forKey: UserDefaultsKeys) {
        userdefault.setValue(value, forKey: forKey.rawValue)
        userdefault.synchronize()
    }

    func string(_ forKey: UserDefaultsKeys) -> String? {
        return userdefault.string(forKey: forKey.rawValue)
    }

    func saveBool(value: Bool, forKey: UserDefaultsKeys) {
        userdefault.setValue(value, forKey: forKey.rawValue)
        userdefault.synchronize()
    }

    func bool(_ forKey: UserDefaultsKeys) -> Bool {
        return userdefault.bool(forKey: forKey.rawValue)
    }
}

extension UserDefaults {
    /// removeAllKeysFromUserDefaults is used to remove all stored keys from userDefault
    func removeAllKeysFromUserDefaults() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
    
    // MARK: - Private Methods
    
    /// these are generic reusable methods not available outside this class
    
    /// Call to save object data in local storage.
    /// Use This function for storing items that don't have their own built-in storage method
    /// and objects that are not simple PList objects.
    /// Bool, URL, Dictionary, Array, [String], Int, Float, Data all have their own built-in
    /// methods, the rest we store as objects of type (`Any?`)
    ///
    /// - Parameters:
    ///   - object: The object data to be stored.
    ///   - key: The key used to get and set the value
    private static func save<T: Codable>(_ object: T, for key: String) {
        // create an encoder to encode the object to data
        let encoder = JSONEncoder()
        
        do {
            // encode and store
            let data = try encoder.encode(object)
            UserDefaults.standard.set(data, forKey: key)
        } catch let error {
            // encoding failed
            print("error encoding: \(error)")
        }
    }
    
    /// Call to retrieve previously stored object data from UserDefaults
    ///
    /// - Parameter key: The key used to get and set the value
    /// - Returns: Optional object of the specified type `T` (e.g. String?, User?) or nil if not found
    private static func get<T: Codable>(for key: String) -> T? {
        // if we do not find the saved data, return nil
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        // the saved data was found so create a decoder to decode it
        let decoder = JSONDecoder()
        do {
            // decode the retrieved data to specified type
            return try decoder.decode(T.self, from: data)
        } catch let error {
            // decoding failed; return nil
            print("error decoding: \(error)")
            return nil
        }
    }
}

enum UserDefaultsKeys: String, CaseIterable {
    case language = "language"
    case appLangauge = "app_lang"
    case isUserConnected = "isUserConnected"
    case userID = "userID"
    case userName = "userName"
    
    case accessToken
    case refreshToken
    case idToken
    case headerAuth
}
