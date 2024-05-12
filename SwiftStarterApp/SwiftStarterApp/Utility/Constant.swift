//
//  Constant.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 01/11/23.
//

import Foundation
import UIKit

enum Constant {
    enum API {
        static var baseURL: String {
            do {
                return try BuildConfiguration.value(for: "BASE_URL")
            } catch {
                fatalError(error.localizedDescription)
            }
        }
    }

    // MARK: - Button title strings
    ///
    enum Button {
        ///
        static let okButton = "OK"
        ///
        static let cancelButton = "Cancel"
        ///
        static let yesButton = "Yes"
        ///
        static let noButton = "No"
        ///
        static let settings = "Settings"
        ///
        static let skip = "Skip"
    }

    // MARK: - Common strings
    ///
    enum Common {
        ///
        static let appTitle = "SwiftStarterApp"
        ///
        static let strReqTimeOut = "The request timed out, Please try again."
        ///
        static let internetAlertMsg = "Please check your internet connection."
        ///
        static let tryAgain: String = "Please try again."
        ///
        static let somethingWrong = "Something went wrong."
    }

    enum Permission {
        static let microphonePermissionTitle = "Microphone access required"
        static let microphonePermissionMsg = "Microphone access enables you to make audio and video calls. Tap Settings, then turn on Microphone."

        static let cameraPermissionTitle = "Camera access required"
        static let cameraPermissionMsg = "Camera access enables you to make video calls. Tap Settings, then turn on Camera."

        static let notificationPermissionTitle = "Notifications are off"
        static let notificationPermissionMsg = "Tap Settings, then Notifications, and turn on Allow Notifications."
    }

    ///
    enum ApiHeaderKeys {
        static let contentType = "Accept"
        static let applicationOrJson = "application/json"
        static let multipartOrFormData = "multipart/form-data"
        static let token = "x-access-token"
    }

    /// response keys
    enum ResponseKeys {
        static let status = "status"
        static let data = "data"
        static let result = "result"
        static let errorMessage = "errorMessage"
    }

    enum ScreenSize {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
}
