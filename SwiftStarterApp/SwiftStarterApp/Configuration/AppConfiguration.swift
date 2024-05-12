//
//  AppConfiguration.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/10/23.
//

import Foundation
import IQKeyboardManagerSwift
import UIKit

class AppConfiguration {
    // MARK: - Shared Instance

    static let shared: AppConfiguration = .init()

    // MARK: - Initializer

    private init() {}
}

// MARK: - Set Root View Controller

extension AppConfiguration {
    func setRootVC() {
        let status = StorageService.shared.isUserConnected ?? false
        var rootVC: UIViewController?
        if status == true {
            rootVC = TabBarController(selectedTab: .home)
        } else {
            let loginVC = LoginViewController.instantiate(appStoryboard: .auth)
            rootVC = UINavigationController(rootViewController: loginVC)
        }
        AppDelegate.shared.window?.rootViewController = rootVC
        AppDelegate.shared.window?.makeKeyAndVisible()
    }
}

// MARK: - Set App Language

extension AppConfiguration {
    func setAppLanguage() {
        let prefferedLanguage = Localize.currentLanguage()
        Localize.setCurrentLanguage(prefferedLanguage)
    }
}

// MARK: - IQKeyboardManager Configuration

extension AppConfiguration {
    func configIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
}

// MARK: - Database Path
extension AppConfiguration {
    func getDatabasePath() {
        if #available(iOS 16.0, *) {
            Logger.log("Database Path: \(URL.documentsDirectory.absoluteString)")
        } else {
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            Logger.log("Database Path: \(paths))")
        }
    }
}
