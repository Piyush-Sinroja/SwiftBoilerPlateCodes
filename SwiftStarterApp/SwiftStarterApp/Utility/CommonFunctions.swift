//
//  CommonFunctions.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 06/11/23.
//

import Foundation
import UIKit
import Kingfisher

class CommonFunctions {

    /// only allow number and given character limit in textfield
    ///
    /// - Parameters:
    ///   - textField: UItextField
    ///   - range: range
    ///   - string: string to pass
    /// - Returns: return's valid or not with bool value.
    class func textFieldWithNumberAndCharacterLimit(textField: UITextField, range: NSRange, string: String, charLength: Int) -> Bool {
        let onlyNo = "0123456789"
        if string.isEmpty {
            return true
        }
        let numberFiltered = string.getFilterCharacterSet(strNumorSym: onlyNo)
        if numberFiltered.isEmpty {
            return false
        }
        return CommonFunctions.textFieldsValidate(textField: textField, charLength: charLength, range: range, replacementString: string)
    }

    /// character limit of textfields set
    ///
    /// - Parameters:
    ///   - textField: current text field
    ///   - charLength: max length of textfield
    ///   - range: range of string
    ///   - string: number of characters
    /// - Returns: return true false value
    class func textFieldsValidate(textField: UITextField, charLength: Int, range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if range.length + range.location > currentCharacterCount {
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= charLength
    }

    class func isShopOpenNow(weekSchedule: [Days: (Int, Int)]) -> Bool {
        let timeZone = TimeZone.current
        let now = Calendar.current.dateComponents(in: timeZone, from: Date())

        guard let weekday = now.weekday,
              let today = Days(rawValue: weekday),
              let hour = now.hour,
              let minute = now.minute else {
            return false
        }

        guard let todayTuple = weekSchedule[today] else {
            return false // no key, means closed
        }

        let opensAt = todayTuple.0
        let closesAt = todayTuple.1

        let rightNowInMinutes = hour * 60 + minute

        return rightNowInMinutes > opensAt && rightNowInMinutes < closesAt

        /* example
        let schedule = [
            Days.mon: (22*60+30, 9*60+30),
            Days.tue: (9*60+30, 23*60+05),
            Days.wed: (9*60+30, 22*60+30),
            Days.thu: (9*60+30, 22*60+30),
            Days.fri: (9*60+30, 22*60+30),
        ]

        if CommonFunctions.isShopOpenNow(weekSchedule: schedule) {
            print("Store open")
        } else {
            print("Store closed")
        }
        */
    }

    /// Generating random string
    ///
    /// - Parameter length: string length
    /// - Returns: Give random string
    class func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        // Hemant Change
        return String((0...length-1).map { _ in letters.randomElement() ?? Character("random") })
    }

    /// Checks minimum space available
    class func isDiskMemoryAvailableToDownload(minMemoryNeedInMB: Int = 50) -> Bool {
        let deviceRemainingSpace = DiskStatus.freeDiskSpaceInBytes
        let availableMB = deviceRemainingSpace / 1024 / 1024
        return availableMB > minMemoryNeedInMB
    }
}
