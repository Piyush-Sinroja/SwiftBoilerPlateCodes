//
//  URL+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 23/11/23.
//

import Foundation

// MARK: - URL Extension

extension URL {
  /// file size
  /// - Returns: return filesize in string format
  func fileSize() -> String? {
    do {
      let attribute = try FileManager.default.attributesOfItem(atPath: self.path)
      if let data = attribute[FileAttributeKey.size] as? NSNumber {
        var size: Double = 0.0
        var unit = "GB"
        size = (Double(truncating: data) / 1024 / 1024 / 1024).roundValue(decimalPlace: 1)
        if size < 1 {
          size = (Double(truncating: data) / 1024 / 1024).roundValue(decimalPlace: 1)
          unit = "MB"
          if size < 1 {
            size = (Double(truncating: data) / 1024).roundValue(decimalPlace: 1)
            unit = "KB"
            if size < 1 {
              size = (Double(truncating: data)).roundValue(decimalPlace: 1)
              unit = "Bytes"
            }
          }
        }
        return String(format: "%.1f \(unit)", size)
      }
    } catch {
      Logger.log("Error: \(error)")
    }
    return nil
  }
  
  var checkFileSize: Int? {
    let value = try? resourceValues(forKeys: [.fileSizeKey])
    return value?.fileSize
  }
}

public extension URL {
  var queryParameters: [String: String]? {
    guard
      let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
      let queryItems = components.queryItems else {
      return nil
    }
    return queryItems.reduce(into: [String: String]()) { result, item in
      result[item.name] = item.value
    }
  }
}

extension URL {
  func appending(_ queryItem: String, value: String?) -> URL {
    guard var urlComponents = URLComponents(string: absoluteString) else {
      return absoluteURL
    }
    var queryItems: [URLQueryItem] = urlComponents.queryItems ?? []
    let queryItem = URLQueryItem(name: queryItem, value: value)
    queryItems.append(queryItem)
    urlComponents.queryItems = queryItems
    return urlComponents.url!
  }
}
