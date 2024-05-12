//
//  Float+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 06/11/23.
//

import Foundation

// MARK: - This extension used to show float type value upto two decimal points.
extension Float {

    // MARK: - Variables
    ///
    var displayTwoPointValue: String {
        return Double(self).display2PointValue
    }

    ///
    var displayOnePointValue: String {
        return Double(self).display1PointValue
    }
}
