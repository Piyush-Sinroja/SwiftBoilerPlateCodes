//
//  Int+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 06/12/23.
//

import Foundation

public extension Int {
  
  /// Convert Int timeIntervalSince1970 to string date
  ///
  /// - Parameter format: date format
  /// - Returns: string date
  func convertToDate(format: DateFormate = .DDMMYYYY) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(self))
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format.rawValue
    return dateFormatter.string(from: date)
  }
}

extension Int {
  ///   Checks if the integer is even.
  public var isEven: Bool { return (self % 2 == 0) }
  
  ///   Checks if the integer is odd.
  public var isOdd: Bool { return (self % 2 != 0) }
  
  ///   Checks if the integer is positive.
  public var isPositive: Bool { return (self > 0) }
  
  ///   Checks if the integer is negative.
  public var isNegative: Bool { return (self < 0) }
  
  ///   Converts integer value to Double.
  public var toDouble: Double { return Double(self) }
  
  ///   Converts integer value to Float.
  public var toFloat: Float { return Float(self) }
  
  public var toCGFloat: CGFloat { return CGFloat(self) }
  
  ///   Converts integer value to String.
  public var toString: String { return String(self) }
  
  ///   Converts integer value to UInt.
  public var toUInt: UInt { return UInt(self) }
  
  ///   Converts integer value to Int32.
  public var toInt32: Int32 { return Int32(self) }
  
  ///   Converts integer value to a 0..<Int range. Useful in for loops.
  public var range: CountableRange<Int> { return 0..<self }
  
  ///   The digits of an integer represented in an array(from most significant to least).
  /// This method ignores leading zeros and sign
  public var digitArray: [Int] {
    var digits = [Int]()
    for char in Array(self.toString) {
      if let digit = Int(String(char)) {
        digits.append(digit)
      }
    }
    return digits
  }
  
  ///   Returns a random integer number in the range min...max, inclusive.
  public static func random(within: Range<Int>) -> Int {
    let delta = within.upperBound - within.lowerBound
    return within.lowerBound + Int(arc4random_uniform(UInt32(delta)))
  }
}
