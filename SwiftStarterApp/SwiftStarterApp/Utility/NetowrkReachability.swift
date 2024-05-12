//
//  NetworkMonitor.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/29/23.
//

import Reachability

final class NetowrkReachability: NSObject {
    // MARK: - Properties

    static var shared = NetowrkReachability()

    fileprivate var reachability: Reachability?

    var isInternetAvailable: Bool?
  
    func startMonitoring() {
        do {
            reachability = try Reachability()
            NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged(_:)), name: Notification.Name.reachabilityChanged, object: reachability)
            try reachability?.startNotifier()
        } catch {
            Logger.log("Unable to start reachability notifier: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Reachability Changed Notification

    @objc func reachabilityChanged(_ notification: Notification) {
        if let reachability = notification.object as? Reachability {
            switch reachability.connection {
            case .wifi, .cellular:
                self.isInternetAvailable = true
            case .none:
                self.isInternetAvailable = false
            case .unavailable:
                self.isInternetAvailable = false
                DispatchQueue.main.async {
                    UIApplication.shared.keyWindow?.rootViewController?.toastMessage("Internet Not Available:")
                }
            }
        } else {
            self.isInternetAvailable = false
            Logger.log("no reachability")
        }
    }
}
