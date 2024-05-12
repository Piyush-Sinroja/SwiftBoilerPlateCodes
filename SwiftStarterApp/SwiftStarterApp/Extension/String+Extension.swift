//
//  String+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 01/11/23.
//

import Foundation

// MARK: - Extension for String Methods

///
extension String {
    /// remove whites space from left & right side of string
    ///
    /// - Returns: final string after removing extra left & right space.
    func removeWhiteSpace() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }

    ///   Capitalizes first character of String
    mutating func capitalizeFirst() {
      guard !self.isEmpty else { return }
      self.replaceSubrange(startIndex...startIndex, with: String(self[startIndex]).capitalized)
    }

    /// split string using a spearator string, returns an array of string
    func split(_ separator: String) -> [String] {
      return self.components(separatedBy: separator).filter {
        !$0.removeWhiteSpace().isEmpty
      }
    }

    /// split string with delimiters, returns an array of string
    func split(_ characters: CharacterSet) -> [String] {
      return self.components(separatedBy: characters).filter {
        !$0.removeWhiteSpace().isEmpty
      }
    }

    /// separate string
    /// - Parameters:
    ///   - stride: string value
    ///   - separator: separator character
    /// - Returns: get separated string
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1]: [$1]}.joined())
    }

    /// Returns the first index of the occurency of the character in String
    func getIndexOf(_ char: Character) -> Int? {
      for (index, c) in self.enumerated() where c == char {
        return index
      }
      return nil
    }

    /// Checks if String contains Emoji
    func includesEmoji() -> Bool {
      for i in 0...self.count {
        let c: unichar = (self as NSString).character(at: i)
        if (0xD800 <= c && c <= 0xDBFF) || (0xDC00 <= c && c <= 0xDFFF) {
          return true
        }
      }
      return false
    }

    /// Counts number of instances of the input inside String
    func countSub(_ substring: String) -> Int {
      return components(separatedBy: substring).count - 1
    }

    /// from base64 to string convertion
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }

    /// string to base64 string
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }

    /// check string is numeric or not
    var isNumeric: Bool {
        guard !self.isEmpty else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }

    // To check String is empty or not
    var isEmptyString: Bool {
        return removeWhiteSpace().isEmpty
    }

    /// Shortcut for string urls like: URL(string: "http://google.com")
    var asURL: URL? {
        return URL(string: self)
    }

    /// Validating a string whether it is hexadecimal color or not using regular expression
    var isValidHex: Bool {
        let hexadecimalFormat = "^#(?:[0-9a-fA-F]{3}){1,2}$"
        return self.matches(hexadecimalFormat)
    }

    /// Return true if the string has only numbers "0123456789".
    var isValidNumber: Bool {
      let numberFormat = "^[0-9]*$"
      return self.matches(numberFormat)
    }

    /// Validate for if regex matches
    ///
    /// - Parameter regex: regular expression
    /// - Returns: true if matches the given regex
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression) != nil
    }

    /// Return only the digits from a string
    var onlyDigits: String {
        let set = NSCharacterSet.decimalDigits.inverted
        return self.components(separatedBy: set).joined(separator: "")
    }

    /// get date from string
    /// - Parameter formate: date formate
    /// - Returns: Date
    func getDateFromString(formate: String, zone: Zone = .local) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        dateFormatter.timeZone = TimeZone(abbreviation: String(describing: zone))
        return dateFormatter.date(from: self)
    }

    func containsDigit() -> Bool {
        self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
    }

    // Convert string to secure string like (ex: 9999999999 -> 99******99, test@gmail.com -> te**********om)
    var secureStringText: String? {
        if self.isEmpty {
            return /* self.prefix(2) + */ String(repeating: "*", count: self.count - 4) + self.suffix(4)
        }
        return nil
    }

    ///
    func getFilterCharacterSet(strNumorSym: String) -> String {
        let aSet = NSCharacterSet(charactersIn: strNumorSym).inverted
        let compSepByCharInSet = self.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return numberFiltered
    }

    func localToUTC(inputDateFormatter: String, outputDateFormatter: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputDateFormatter
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        return getStringFromDate(dateFormatter: dateFormatter, strDate: self, outputDateFormatter: outputDateFormatter, timeZone: TimeZone(abbreviation: Zone.utc.rawValue) ?? .current)
    }

    func utcToLocal(inputDateFormatter: String, outputDateFormatter: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputDateFormatter
        dateFormatter.timeZone = TimeZone(abbreviation: Zone.utc.rawValue)
        return getStringFromDate(dateFormatter: dateFormatter, strDate: self, outputDateFormatter: outputDateFormatter, timeZone: TimeZone.current)
    }

    // public func makeParams<T, K>(_ params: Dictionary<T, K>) -> String? {
    func makeParams(_ params: Dictionary<String, String>) -> String? {

      var string = self
      var index = 0
      for (key, value) in params {
        if index == 0 {
          string += "?"
        } else {
          string += "&"
        }
        string = string.appendingFormat("%@=%@", key, value)
        index += 1
      }

      return string
    }

  ///   Cut string from range
 private subscript(integerRange: Range<Int>) -> String {
    let start = self.index(startIndex, offsetBy: integerRange.lowerBound)
    let end = self.index(startIndex, offsetBy: integerRange.upperBound)
    return String(self[start..<end])
  }

  ///   Cut string from closedrange
  private subscript(integerClosedRange: ClosedRange<Int>) -> String {
    return self[integerClosedRange.lowerBound..<(integerClosedRange.upperBound + 1)]
  }

  func stringFromIndex(_ count: Int) -> String? {
    if self.count > count {
      return  self[(count-1)...count]
    } else {
      return nil
    }
  }
    private func getStringFromDate(dateFormatter: DateFormatter, strDate: String, outputDateFormatter: String, timeZone: TimeZone) -> String? {
        guard let date = dateFormatter.date(from: self) else {
            return nil
        }
        dateFormatter.timeZone = timeZone
        dateFormatter.dateFormat = outputDateFormatter
        return dateFormatter.string(from: date)
    }
}

// MARK: - Validation

extension String {
    
    func isEmpty() -> Bool {
        guard !self.isEmpty else {
            return false
        }
        return true
    }
    
    // check valid email id
    func isValidEmailId() -> Bool {
        guard !self.isEmpty else {
            return false
        }
        let emailRegEx = "[.0-9a-zA-Z_-]+@[0-9a-zA-Z.-]+\\.[a-zA-Z]{2,20}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        if !emailTest.evaluate(with: self) {
            return false
        }
        return true
    }

    // check valid Password
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z!@#$£€§%…^&*\\/()\\[\\]\\-_=+{}|?>.<,:;~`'\"/\\\\]{8,128}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
    
    //Password must have at least 6 characters
    func isMinValue(value: String, maxValue: Int) -> Bool {
        if value.count >= maxValue {
            return true
        }
        return false
    }
}

// MARK: - Version comparison methods
public extension String {

  /// Inner comparison helper to handle same versions with different length. (Ex: "1.0.0" & "1.0")
  private func compare(toVersion targetVersion: String) -> ComparisonResult {

    let versionDelimiter = "."
    var result: ComparisonResult = .orderedSame
    var versionComponents = components(separatedBy: versionDelimiter)
    var targetComponents = targetVersion.components(separatedBy: versionDelimiter)
    let spareCount = versionComponents.count - targetComponents.count

    if spareCount == 0 {
      result = compare(targetVersion, options: .numeric)
    } else {
      let spareZeros = repeatElement("0", count: abs(spareCount))
      if spareCount > 0 {
        targetComponents.append(contentsOf: spareZeros)
      } else {
        versionComponents.append(contentsOf: spareZeros)
      }
      result = versionComponents.joined(separator: versionDelimiter)
        .compare(targetComponents.joined(separator: versionDelimiter), options: .numeric)
    }
    return result
  }

  func isVersion(equalTo targetVersion: String) -> Bool {
    return compare(toVersion: targetVersion) == .orderedSame
  }

  func isVersion(greaterThan targetVersion: String) -> Bool {
    return compare(toVersion: targetVersion) == .orderedDescending
  }

  func isVersion(greaterThanOrEqualTo targetVersion: String) -> Bool {
    return compare(toVersion: targetVersion) != .orderedAscending
  }

  func isVersion(lessThan targetVersion: String) -> Bool {
    return compare(toVersion: targetVersion) == .orderedAscending
  }

  func isVersion(lessThanOrEqualTo targetVersion: String) -> Bool {
    return compare(toVersion: targetVersion) != .orderedDescending
  }
}

extension String {
  public func convertToDictionary() -> [String: Any]? {
    if let data = self.data(using: .utf8) {
      do {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
      } catch {
        print(error.localizedDescription)
      }
    }
    return nil
  }
}

extension NSAttributedString {
  public func height(withConstrainedWidth width: CGFloat) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

    return ceil(boundingBox.height)
  }

  public func width(withConstrainedHeight height: CGFloat) -> CGFloat {
    let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
    let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)

    return ceil(boundingBox.width)
  }
}
