//
//  TimeInterval+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 06/12/23.
//

import Foundation

// MARK: - TimeInterval Extension

public extension TimeInterval {
  
  static var oneHour: TimeInterval {
    return 3600
  }
  
  static var twoHour: TimeInterval {
    return oneHour * 2
  }
  
  static var oneDay: TimeInterval {
    return oneHour * 24
  }
  
  static var twoDays: TimeInterval {
    return oneDay * 2
  }
  
  static var threeDays: TimeInterval {
    return oneDay * 3
  }
  
  static var oneWeek: TimeInterval {
    return oneDay * 7
  }
  
  static var oneMonth: TimeInterval {
    return oneDay * 30
  }
  
  static var oneYear: TimeInterval {
    return oneDay * 365
  }
  
  static func customHour(hour: Int) -> TimeInterval {
    return oneHour * Double(hour)
  }
}
