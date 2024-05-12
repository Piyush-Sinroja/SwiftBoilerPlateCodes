//
//  UIDevice+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 07/12/23.
//

import Foundation
import UIKit

extension UIDevice {

    /// get device name
    public var deviceName: String {
        return UIDevice.current.name
    }

    /// get device language
    public var deviceLanguage: String {
        return Bundle.main.preferredLocalizations[0]
    }

    /// Returns true if the device is iPhone
    public var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }

    /// Returns true if the device is iPad
    public var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }

    /// Returns device systemName
    public var deviceSystemName: String {
        return UIDevice.current.systemName
    }

    /// Returns device model
    public var deviceModel: String {
        return UIDevice.current.model
    }

    /// Returns device OsVersion
    public var deviceOsVersion: String {
        return UIDevice.current.systemVersion
    }

    /// Returns device battery level
    public var deviceBatteryLevel: Float {
        UIDevice.current.isBatteryMonitoringEnabled = true
        return UIDevice.current.batteryLevel
    }

    public class func hasNotch() -> Bool {
        let bottom = UIApplication.shared.keyWindow?.windowScene?.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
