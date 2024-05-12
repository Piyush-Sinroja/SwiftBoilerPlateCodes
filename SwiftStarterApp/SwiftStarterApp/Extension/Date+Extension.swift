//
//  Date+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 06/11/23.
//

import Foundation

/// Cases of the date formate
public enum DateFormate: String {
    /// MMMMddYYYYWithTime: OCT 10, 2019 at 12:32 am
    case MMMMddYYYYWithTime = "MMMM dd, yyyy 'at' h:mm a"
    /// ddmmyyyyWithTime: 23/10/2019 at 12:32 am
    case ddmmyyyyWithTime = "dd/MM/yyyy 'at' h:mm a"
    case  requestDateFormat = "dd-MM-yyyy hh:mm:ss.SSSSS"
    case yyyyMMddWith24TimeAndTimeZone = "yyyy-MM-dd HH:mm:ss Z"
    case yyyyMMddWith12HourTime = "yyyy-MM-dd hh:mm a"
    case YYYYMMDD = "yyyyMMdd"
    case DDMMYYYY = "dd MM yyyy"
    case DateWithTimeZone = "yyyy-MM-dd'T'HH:mm:Ss.SSSZ" // Time zone date
    case MMMYYY = "MMM yyy" /// For date used in view bills
    case MMM = "MMM"
    case ddmmyyyy = "dd/MM/yyyy"

    /*
     You can add as many format as you want
     and if you not familiar with other date format you can use this website
     to pick your best format http://nsdateformatter.com
     */
}

// MARK: - Date Extension

extension Date {

    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    var isPast: Bool {
        return isPast(referenceDate: Date())
    }

    var isFuture: Bool {
        return !isPast
    }

    func isPast(referenceDate: Date) -> Bool {
        return timeIntervalSince(referenceDate) <= 0
    }

    func isFuture(referenceDate: Date) -> Bool {
        return !isPast(referenceDate: referenceDate)
    }

    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }

    init?(value: String, format: String) {
        let aDtFormatter = DateFormatter()
        aDtFormatter.dateFormat = format

        if let date = aDtFormatter.date(from: value) {
            self = date
        } else {
            return nil
        }
    }

    init?(value: String, format: String, timeZone: TimeZone? = nil) {
        let aDtFormatter = DateFormatter()
        aDtFormatter.dateFormat = format
        if let value = timeZone {
            aDtFormatter.timeZone = value
        }

        if let date = aDtFormatter.date(from: value) {
            self = date
        } else {
            return nil
        }
    }

    /// Getting the current date in selected format
    ///
    /// - Parameter format: date format
    /// - Returns: the current date in the selected format
    func getCurrentDate(format: DateFormate = .DDMMYYYY) -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.dateFormat = format.rawValue // from enum dateFormat
        let formatedDate = formatter.string(from: date)

        return formatedDate
    }

    /// Getting the current date by passing your custom date format
    ///
    /// - Parameter formatToUse: your custom date format
    /// - Returns: current date
    func getCurrentDateUsingThisFormat(_ formatToUse: DateFormate = .ddmmyyyyWithTime) -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.dateFormat = formatToUse.rawValue
        let formatedDate = formatter.string(from: date)

        return formatedDate
    }

    /// Calculating the time interval since a given date
    ///
    /// - Parameter date: Date()
    /// - Returns: time interval
    func timeSince(_ date: Date) -> TimeInterval {
        let time = Date()
        return time.timeIntervalSince(date)
    }

    /// get current time stamp
    /// - Returns: current time stamp in Int
    func getCurrentTimeStampinINT() -> Int {
        let currentTime = Date().timeIntervalSince1970
        let timeStap = Int(currentTime)
        return timeStap
    }
}

extension Date {
    /// Returns the amount of years from another date
    func yearsCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func monthsCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeksCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func daysCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hoursCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutesCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func secondsCount(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }

    /// Returns the a custom time interval description from another date
    func timeAgoDisplayApproach1(from date: Date) -> String {
        if yearsCount(from: date)   > 0 { return "\(yearsCount(from: date))years ago"   }
        if monthsCount(from: date)  > 0 { return "\(monthsCount(from: date))months ago"  }
        if weeksCount(from: date)   > 0 { return "\(weeksCount(from: date))weeks ago"   }
        if daysCount(from: date)    > 0 { return "\(daysCount(from: date))days ago"    }
        if hoursCount(from: date)   > 0 { return "\(hoursCount(from: date))hours ago"   }
        if minutesCount(from: date) > 0 { return "\(minutesCount(from: date))minutes ago" }
        if secondsCount(from: date) > 0 { return "\(secondsCount(from: date))seconds ago" }
        return ""
    }

    func timeAgoDisplayApproach2() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }

    ///   Easy creation of time ago String. Can be Years, Months, days, hours, minutes or seconds
    public func timeAgoDisplayApproach3() -> String {
      let date = Date()
      let calendar = Calendar.current
      let components = (calendar as NSCalendar).components([.year, .month, .day, .hour, .minute, .second], from: self, to: date, options: [])
      var str: String

      let year = components.year ?? 0
      let month = components.month ?? 0
      let day = components.day ?? 0
      let hour = components.hour ?? 0
      let minute = components.minute ?? 0
      let second = components.second ?? 0

      if year >= 1 {
        components.year == 1 ? (str = "year") : (str = "years")
        return "\(year) \(str) ago"
      } else if month >= 1 {
        month == 1 ? (str = "month") : (str = "months")
        return "\(month) \(str) ago"
      } else if day >= 1 {
        day == 1 ? (str = "day") : (str = "days")
        return "\(day) \(str) ago"
      } else if hour >= 1 {
        hour == 1 ? (str = "hour") : (str = "hours")
        return "\(hour) \(str) ago"
      } else if minute >= 1 {
        minute == 1 ? (str = "minute") : (str = "minutes")
        return "\(minute) \(str) ago"
      } else if second >= 1 {
        second == 1 ? (str = "second") : (str = "seconds")
        return "\(second) \(str) ago"
      } else {
        return "Just now"
      }
    }

    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HHmmss"
        return dateFormatter.string(from: self)
    }
    
    func stringFromDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = DateFormate.ddmmyyyy.rawValue
        return dateFormatter.string(from: self)
    }
}
