//
//  Bundle+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 06/11/23.
//

import Foundation

// MARK: - Bundle Extension

public extension Bundle {

    /// Retrieves the `infoDictionary` dictionary inside Bundle and
    /// returns the value accessed with the key `CFBundleName`.
    var appName: String? {
        guard let infoDictionary = Bundle.main.infoDictionary else { return nil }
        guard let name = infoDictionary["CFBundleName"] as? String else { return nil }
        return name
    }

    /// Retrieves the `infoDictionary` dictionary inside Bundle and
    /// returns the value accessed with the key `CFBundleIdentifier`.
    var bundleIdentifier: String? {
        guard let infoDictionary = Bundle.main.infoDictionary else { return nil }
        guard let bundleIdentifier = infoDictionary["CFBundleIdentifier"] as? String else { return nil }
        return bundleIdentifier
    }

    /// Retrieves the `infoDictionary` dictionary inside Bundle and
    /// returns the value accessed with the key `CFBundleVersion`.
    var buildNumber: String? {
        guard let infoDictionary = Bundle.main.infoDictionary else { return nil }
        guard let buildNumber = infoDictionary["CFBundleVersion"] as? String else { return nil }
        return buildNumber
    }

    /// Retrieves the `infoDictionary` dictionary inside Bundle and
    /// returns the value accessed with the key `CFBundleShortVersionString`.
    var versionNumber: String? {
        guard let infoDictionary = Bundle.main.infoDictionary else { return nil }
        guard let versionNumber = infoDictionary["CFBundleShortVersionString"] as? String else { return nil }
        return versionNumber
    }

    /// Retrieves the `infoDictionary` dictionary inside Bundle, retrieves
    /// the value accessed with the key `CFBundleShortVersionString` and parses
    /// it to return the version major number.
    ///
    /// - Returns: the version number of the Xcode project as a whole(e.g. 1.0.3)
    var versionMajorNumber: String? {
        guard let infoDictionary = Bundle.main.infoDictionary else { return nil }
        guard let versionNumber = infoDictionary["CFBundleShortVersionString"] as? String else { return nil }
        return versionNumber.components(separatedBy: ".")[0]
    }

    /// Retrieves the `infoDictionary` dictionary inside Bundle, retrieves
    /// the value accessed with the key `CFBundleShortVersionString` and parses
    /// it to return the version minor number.
    var versionMinorNumber: String? {
        guard let infoDictionary = Bundle.main.infoDictionary else { return nil }
        guard let versionNumber = infoDictionary["CFBundleShortVersionString"] as? String else { return nil }
        return versionNumber.components(separatedBy: ".")[1]
    }

    /// Retrieves the `infoDictionary` dictionary inside Bundle, retrieves
    /// the value accessed with the key `CFBundleShortVersionString` and parses
    /// it to return the version patch number.
    var versionPatchNumber: String? {
        guard let infoDictionary = Bundle.main.infoDictionary else { return nil }
        guard let versionNumber = infoDictionary["CFBundleShortVersionString"] as? String else { return nil }
        return versionNumber.components(separatedBy: ".")[2]
    }

    /// Retrieves the `infoDictionary` dictionary inside Bundle, and retrieves
    /// all the values inside it
    var getInfoDictionary: [String: Any] {
        guard let infoDictionary = Bundle.main.infoDictionary else { return [:] }
        return infoDictionary
    }

}
