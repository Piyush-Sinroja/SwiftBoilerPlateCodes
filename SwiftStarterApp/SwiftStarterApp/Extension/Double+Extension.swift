//
//  Double+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 06/11/23.
//

import Foundation

// MARK: - This extension used to show double type value upto two decimal points.
extension Double {

    // MARK: - Variables
    ///
    var display2PointValue: String {
        return self.formatDecimals()
    }

    ///
    var display1PointValue: String {
        return self.formatDecimals(forPlaces: 1)
    }

    /// This function is used to formate decimals by passing number of places.
    ///
    /// - Parameter places: place to show decimal points.
    /// - Returns: Converted String value.
    private func formatDecimals(forPlaces places: Int = 2) -> String {
        let format = ".\(places)"
        return String(format: "%\(format)f", self)
    }

    func roundValue(decimalPlace: Int) -> Double {
        let format = NSString(format: "%%.%if", decimalPlace)
        let string = NSString(format: format, self)
        return Double(atof(string.utf8String))
    }
}
