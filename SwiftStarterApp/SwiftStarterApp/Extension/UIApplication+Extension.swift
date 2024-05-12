//
//  UIApplication+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/1/23.
//

import UIKit

// MARK: - UIApplication Extension

extension UIApplication {
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}
