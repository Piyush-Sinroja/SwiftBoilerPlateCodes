//
//  Array+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 06/11/23.
//

import Foundation

// MARK: - Array Extension

public extension Array {
  
  /// Random item from array.
  var randomItem: Element? {
    if self.isEmpty { return nil }
    let index = Int(arc4random_uniform(UInt32(count)))
    return self[index]
  }
  
  /// Shuffled version of array.
  var shuffled: [Element] {
    var arr = self
    arr.shuffle()
    return arr
  }
  
  /// Element at the given index if it exists.
  ///
  /// - Parameter index: index of element.
  /// - Returns: optional element (if exists).
  func item(at index: Int) -> Element? {
    guard index >= 0 && index < count else { return nil }
    return self[index]
  }
  
  @discardableResult
  mutating func append(_ newArray: Array) -> CountableRange<Int> {
    let range = count..<(count + newArray.count)
    self += newArray
    return range
  }
  
  @discardableResult
  mutating func insert(_ newArray: Array, at index: Int) -> CountableRange<Int> {
    let mIndex = Swift.max(0, index)
    let start = Swift.min(count, mIndex)
    let end = start + newArray.count
    
    let left = self[0..<start]
    let right = self[start..<count]
    self = left + newArray + right
    return start..<end
  }
  
  mutating func remove<T: AnyObject> (_ element: T) {
    let anotherSelf = self
    removeAll(keepingCapacity: true)
    anotherSelf.each { (_: Int, current: Element) in
      if (current as? T) !== element {
        self.append(current)
      }
    }
  }
  
  func each(_ exe: (Int, Element) -> Void) {
    for (index, item) in enumerated() {
      exe(index, item)
    }
  }
  
}

public extension Array where Element: Equatable {

  /// Remove Dublicates.
  var unique: [Element] {
    return self.reduce([]) { $0.contains($1) ? $0 : $0 + [$1] }
  }

  /// Check if array contains an array of elements.
  ///
  /// - Parameter elements: array of elements to check.
  /// - Returns: true if array contains all given items.
  func contains(_ elements: [Element]) -> Bool {
    guard !elements.isEmpty else {
      return false
    }
    var found = true
    for element in elements where !contains(element) {
      found = false
    }
    return found
  }

  /// All indexes of specified item.
  ///
  /// - Parameter item: item to check.
  /// - Returns: an array with all indexes of the given item.
  func indexes(of item: Element) -> [Int] {
    var indexes: [Int] = []
    for index in 0..<self.count where self[index] == item {
      indexes.append(index)
    }
    return indexes
  }

  /// Remove all instances of an item from array.
  ///
  /// - Parameter item: item to remove.
  mutating func removeAll(_ item: Element) {
    self = self.filter { $0 != item }
  }

  /// Creates an array of elements split into groups the length of size.
  /// If array can’t be split evenly, the final chunk will be the remaining elements.
  ///
  /// - parameter array: to chunk
  /// - parameter size: size of each chunk
  /// - returns: array elements chunked
  func chunk(size: Int = 1) -> [[Element]] {
    var result = [[Element]]()
    var chunk = -1
    for (index, elem) in self.enumerated() {
      if index % size == 0 {
        result.append([Element]())
        chunk += 1
      }
      result[chunk].append(elem)
    }
    return result
  }

  /// Description
  ///
  /// - Parameter map: uniqueSet
  /// - Returns: unique Array
  func uniqueSet<T: Hashable> (map: ((Element) -> (T))) -> [Element] {
    var set = Set<T>() // the unique list kept in a Set for fast retrieval
    var arrayOrdered = [Element]() // keeping the unique list of elements but ordered
    for value in self where !set.contains(map(value)) {
      set.insert(map(value))
      arrayOrdered.append(value)
    }
    return arrayOrdered
  }

  ///   Difference of self and the input arrays.
  func difference(_ values: [Element]...) -> [Element] {
    var result = [Element]()
  elements: for element in self {
    for value in values where value.contains(element) {
      continue elements
    }
    //  element it's only in self
    result.append(element)
  }
    return result
  }

  /// Intersection of self and the input arrays.
  func intersection(_ values: [Element]...) -> Array {
    var result = self
    var intersection = Array()

    for (i, value) in values.enumerated() {
      //  the intersection is computed by intersecting a couple per loop:
      //  self n values[0], (self n values[0]) n values[1], ...
      if i > 0 {
        result = intersection
        intersection = Array()
      }

      //  find common elements and save them in first set
      //  to intersect in the next loop
      value.forEach { (item: Element) -> Void in
        if result.contains(item) {
          intersection.append(item)
        }
      }
    }
    return intersection
  }

  /// Union of self and the input arrays.
  func union(_ values: [Element]...) -> Array {
    var result = self
    for array in values {
      for value in array where !result.contains(value) {
        result.append(value)
      }
    }
    return result
  }

  ///   Removes the first given object
  mutating func removeFirst(_ element: Element) {
    guard let index = firstIndex(of: element) else { return }
    self.remove(at: index)
  }

  ///   Returns the last index of the object
  func lastIndex(of element: Element) -> Int? {
    return indexes(of: element).last
  }

}
