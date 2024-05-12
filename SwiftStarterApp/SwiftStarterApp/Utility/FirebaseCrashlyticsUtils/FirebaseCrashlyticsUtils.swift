//
//  FirebaseCrashlyticsUtils.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 12/11/23.
//

import Foundation
import FirebaseCrashlytics

// MARK: - GA Constants
class GAConstant: NSObject {
    public static let CRASHLYTICS_USER_LOGGED = "user_logged"
}

// MARK: - Firebase Crashlytics Utils
class FirebaseCrashlyticsUtils: NSObject {
    
    public static let shared: FirebaseCrashlyticsUtils = .init()

    class func setCustomValue(_ value: Any, forKey key: String) {
        Crashlytics.crashlytics().setCustomValue(value, forKey: key)
    }
}
