//
//  AppDelegate.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 10/31/23.
//

import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import Firebase
import IQKeyboardManagerSwift
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var orientationLock = UIInterfaceOrientationMask.portrait
    static var shared: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("could not get app delegate ")
        }
        return delegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        initializeAwsAmplify()
        
        /// Firebase Configuration
        FirebaseApp.configure()
        
        /// Network Reachability Check
        NetowrkReachability.shared.startMonitoring()
        
        /// Set Root View Controller
        AppConfiguration.shared.setRootVC()
        
        /// Set IQKeyboardManager COnfiguration
        AppConfiguration.shared.configIQKeyboardManager()
        
        /// Database Path
        AppConfiguration.shared.getDatabasePath()
        return true
    }
    
    func initializeAwsAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            // and so on ...
            try Amplify.configure()
        } catch {
            Logger.log("Error initializing Amplify: \(error)")
            assertionFailure("Error initializing Amplify: \(error)")
        }
    }
}

extension AppDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        switch self.orientationLock {
        case .all:
            return UIInterfaceOrientationMask.all
        case .portrait:
            return UIInterfaceOrientationMask.portrait
        case .landscape:
            return UIInterfaceOrientationMask.landscape
        default:
            return UIInterfaceOrientationMask.portrait
        }
    }
}
