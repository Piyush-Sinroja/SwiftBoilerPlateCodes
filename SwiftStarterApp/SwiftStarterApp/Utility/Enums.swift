//
//  Enums.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 03/11/23.
//

import Foundation

/// Enum For Storyboard
enum Storyboard: String {
    ///
    case main = "Main"
    
    case auth = "Auth"

    case setting = "Setting"

    case tabs = "Tabs"

    case locations = "Locations"
    
    case Common = "Common"
    
    var filename: String {
        return rawValue
    }
}

/// Enum For cornerRadius
enum CornerRadius: CGFloat {
    ///
    case small = 3.0
    ///
    case medium = 5.0
    ///
    case regular = 8.0
    ///
    case big = 12.0
    ///
    var filename: CGFloat {
        return rawValue
    }
}

enum Days: Int {
    case sun = 1
    case mon = 2
    case tue = 3
    case wed = 4
    case thu = 5
    case fri = 6
    case sat = 7
}

enum Zone: String {
    case local
    case utc
    case gmt
}

enum MimeType: String {
    case png = "image/png"
    case jpg = "image/jpg"
    case m4a = "audio/m4a"
    case videoMp4 = "video/mp4"
}

enum EnumReminderDay: Int, CaseIterable {

  case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

  /// day name
  var dayName: String {
    switch self {
      case .sunday:
        return "Sunday"
      case .monday:
        return "Monday"
      case .tuesday:
        return "Tuesday"
      case .wednesday:
        return "Wednesday"
      case .thursday:
        return "Thursday"
      case .friday:
        return "Friday"
      case .saturday:
        return "Saturday"
    }
  }

  var shortName: String {
    return String(dayName.prefix(3))
  }

  static var weekDays: [Int] {
    return [EnumReminderDay.monday.rawValue,
            EnumReminderDay.tuesday.rawValue,
            EnumReminderDay.wednesday.rawValue,
            EnumReminderDay.thursday.rawValue,
            EnumReminderDay.friday.rawValue]
  }

  static var weekends: [Int] {
    return [EnumReminderDay.saturday.rawValue,
            EnumReminderDay.sunday.rawValue]
  }

  /// select reminder day
  /// - Parameter dayNo: day no
  /// - Returns: enum for particular day
  static func selectReminderDay(dayNo: Int) -> EnumReminderDay? {
    switch dayNo {
      case 1:
        return EnumReminderDay.sunday
      case 2:
        return EnumReminderDay.monday
      case 3:
        return EnumReminderDay.tuesday
      case 4:
        return EnumReminderDay.wednesday
      case 5:
        return EnumReminderDay.thursday
      case 6:
        return EnumReminderDay.friday
      case 7:
        return EnumReminderDay.saturday
      default:
        return nil
    }
  }
}
