//
//  Color.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/6/23.
//

import Foundation
import UIKit

/*
 How to use:
    = UIColor.hex_FF0000_Red    // Using Custom Color Class
    = UIColor.hexFF0000Red      // Using Assets Color
 
 */

extension UIColor {
    static let hex_000000_Black = UIColor(named: AppColor.hex_000000_Black.description)!
    static let hex_808080_Gray = UIColor(named: AppColor.hex_808080_Gray.description)!
    static let hex_3A3B3C_DarkGray = UIColor(named: AppColor.hex_3A3B3C_DarkGray.description)!
    static let hex_808080_White = UIColor(named: AppColor.hex_808080_White.description)!
    static let hex_FF0000_Red = UIColor(named: AppColor.hex_FF0000_Red.description)!

}

public enum AppColor: CaseIterable {
    case hex_000000_Black
    case hex_808080_Gray
    case hex_808080_White
    case hex_FF0000_Red
    case hex_3A3B3C_DarkGray
}

extension AppColor: Codable {
    /// A string description for the AppColor
    public var description: String {
        switch self {
            
        case .hex_000000_Black:
            return "hex_000000_Black"
        case .hex_808080_Gray:
            return "hex_808080_Gray"
        case .hex_808080_White:
            return "hex_808080_White"
        case .hex_FF0000_Red:
            return "hex_FF0000_Red"
        case .hex_3A3B3C_DarkGray:
            return "hex_3A3B3C_DarkGray"
        }
    }
    
    /// The debug description
    public var debugDescription: String {
        ".\(self)"
    }
}
