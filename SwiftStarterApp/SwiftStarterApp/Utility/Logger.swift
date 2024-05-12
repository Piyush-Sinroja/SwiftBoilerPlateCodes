//
//  Logger.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 01/11/23.
//

import Foundation

class Logger {

    // static let logger = Log()

    // MARK: - Print on debug area
    class func log<T>(_ value: T...) {
        print("dev: \(value)")
        // logger.write("\n: \(value)")
//        if Environment.current() == .dev {
//            print("dev: \(value)")
//        }
    }
}

/*
struct Log: TextOutputStream {

    func write(_ string: String) {
        let log = FileManage.documentsDirectory().appendingPathComponent("SwiftStarterApp.txt")
        if let handle = try? FileHandle(forWritingTo: log) {
            handle.seekToEndOfFile()
            handle.write(string.data(using: .utf8)!)
            handle.closeFile()
        } else {
            try? string.data(using: .utf8)?.write(to: log)
        }
    }
}
*/
