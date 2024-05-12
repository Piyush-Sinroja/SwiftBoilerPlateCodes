//
//  Fonts.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/6/23.
//

import Foundation
import UIKit

// MARK: - Custom Font OpenSans
enum OpenSansWeight {
    case regular
    case semiBold
    case light
    case bold
        
    var name: String {
        switch self {
        case .regular:
            return "OpenSans-Regular"
        case .semiBold:
            return "OpenSans-SemiBold"
        case .light:
            return "OpenSans-Light"
        case .bold:
            return "OpenSans-Bold"
        }
    }
}

extension UIFont {
    static func openSans(of size: CGFloat, in weight: OpenSansWeight) -> UIFont? {
        UIFont(name: weight.name, size: size)
    }
}
