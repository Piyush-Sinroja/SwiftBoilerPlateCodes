//
//  LocalNotificationManager.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/12/23.
//

import UIKit

/// This class is used to create, remove local notification
class LocalNotificationManager: NSObject {

    // MARK: - Variables

    static let shared = LocalNotificationManager()

    private override init() {
        super.init()
    }

    // MARK: - Notification Permission

    /// notification permission ask
    /// - Parameter completion: completion block with isGranted bool and error
    func notificationPermissionAsk(completion: @escaping (_ isGranted: Bool, _ error: Error?) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { (granted, error) in
                completion(granted, error)
            }
        )
    }

    /// check notification permission
    /// - Parameter completion: completion block with isGranted bool and error
    func checkNotificationPermission(completion: @escaping (_ isGranted: Bool, _ error: Error?) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { setting in
            switch setting.authorizationStatus {
                case .notDetermined:
                    self.notificationPermissionAsk(completion: completion)
                case .denied:
                    completion(false, nil)
                case .authorized, .provisional:
                    completion(true, nil)
                case .ephemeral:
                    completion(true, nil)
                @unknown default:
                    completion(false, nil)
            }
        }
    }

    // MARK: - Create Notification

    /// create notification
    /// - Parameters:
    ///   - time: trigger time
    ///   - reminderDays: repeating days
    ///   - categoryIdentifier: The identifier of the notification’s category.
    ///   - requestIdentifier: The identifier of the notification thread and used in notification request
    ///   - completion: completion block with success/false or error
    func createNotification(time: (hour: Int, min: Int), reminderDays: [Int], categoryIdentifier: String, requestIdentifier: String, completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {
        checkNotificationPermission { [weak self] isGranted, error in
            guard isGranted else {
                completion(isGranted, error)
                return
            }
            self?.removeNotificationWith(identifiers: [requestIdentifier]) { [weak self] in
                if reminderDays.isEmpty {
                    self?.scheduleNotification(weekDay: nil, categoryIdentifier: categoryIdentifier, time: time, requestIdentifier: requestIdentifier, repeats: false, notificationImg: nil, completion: completion)
                } else {
                    if reminderDays.count == EnumReminderDay.allCases.count {
                        self?.scheduleNotification(weekDay: nil, categoryIdentifier: categoryIdentifier, time: time, requestIdentifier: requestIdentifier, repeats: true, notificationImg: nil, completion: completion)
                    } else {
                        for selectedReminderDay in reminderDays {
                            self?.scheduleNotification(weekDay: selectedReminderDay, categoryIdentifier: categoryIdentifier, time: time, requestIdentifier: requestIdentifier, repeats: true, notificationImg: nil, completion: completion)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Remove Notification

    /// remove notification
    /// - Parameters:
    ///   - identifiers: identifiers by which we have requested notification
    ///   - completion: completion block
    func removeNotificationWith(identifiers: [String], completion: @escaping () -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            for identifierName in identifiers {
                let allIndentifier = requests.filter({$0.content.threadIdentifier == identifierName}).map({$0.identifier})
                Logger.log("Removing system notification for identifiers \(allIndentifier)")
                center.removePendingNotificationRequests(withIdentifiers: allIndentifier)
            }
            completion()
        })
    }

    /// remove all notification
    func removeAllNotification() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }

    // MARK: - Helper Method

    /// create local url for image
    /// - Parameter name: image name which exist in image asset
    /// - Returns: image path url
    func createLocalUrl(forImageNamed name: String, img: UIImage) -> URL? {
        let fileManager = FileManager.default
        guard let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
        let url = cacheDirectory.appendingPathComponent("\(name).png")
        let path = url.path
        if !fileManager.fileExists(atPath: path) {
            guard let data = img.pngData() else {return nil}
            fileManager.createFile(atPath: path, contents: data, attributes: nil)
        }
        return url
    }

    // MARK: - Private Method

    /// schedule local notification
    /// - Parameters:
    ///   - weekDay: week day
    ///   - categoryIdentifier: categoryIdentifier
    ///   - time: notification time
    ///   - requestIdentifier: requestIdentifier
    ///   - repeats: passing true if repeating days > 0 or false
    private func scheduleNotification(weekDay: Int?, categoryIdentifier: String, time: (hour: Int, min: Int), requestIdentifier: String, repeats: Bool, notificationImg: UIImage?, completion: @escaping (_ isSuccess: Bool, _ error: Error?) -> Void) {

        let content = UNMutableNotificationContent()
        content.title = "SwiftStarter"
        content.body = "You have a scheduled notification."
        content.sound = UNNotificationSound.default
        content.threadIdentifier = requestIdentifier
        content.categoryIdentifier = categoryIdentifier

        var dateInfo = DateComponents()
        dateInfo.hour = time.hour
        dateInfo.minute = time.min
        dateInfo.timeZone = .current

        var requestIdentifier = "\(requestIdentifier)"
        if let reminderWeekDay = weekDay {
            dateInfo.weekday = reminderWeekDay
            requestIdentifier += "-\(reminderWeekDay)"
        }

        let name = "ImgNotification"
        if let notificationImg = notificationImg,
           let zoneImgUrl = createLocalUrl(forImageNamed: "\(name)\(requestIdentifier)", img: notificationImg) {
            do {
                let attachment = try UNNotificationAttachment(identifier: "\(name)\(requestIdentifier)", url: zoneImgUrl, options: nil)
                content.attachments = [attachment]
            } catch {
                Logger.log(error.localizedDescription)
            }
        }

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: repeats)
        let request = UNNotificationRequest(
            identifier: requestIdentifier,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().delegate = self
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if error == nil {
                completion(true, nil)
                Logger.log("Reminder Created Id \(request.identifier) And Time:", "\(time.hour)", ":", "\(time.min)")
            } else {
                completion(false, error)
                Logger.log("ERROR of Creating Reminder:", error?.localizedDescription)
            }
        }
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension LocalNotificationManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let application = UIApplication.shared
        // Determine the user action
        switch response.actionIdentifier {
            case UNNotificationDismissActionIdentifier:
                Logger.log("Dismiss Action")
            case UNNotificationDefaultActionIdentifier:
                Logger.log("Default")
                if application.applicationState == .active {
                    Logger.log("user tapped the notification bar when the app is in foreground")
                } else if application.applicationState == .inactive {
                    Logger.log("user tapped the notification bar when the app is in background")
                }
            case "Snooze":
                Logger.log("Snooze")
            case "Delete":
                Logger.log("Delete")
            default:
                Logger.log("Unknown action")
        }
        if response.notification.request.identifier == "SampleNotitificationRequest" {
            Logger.log("Tapped in notification")
            print(response)
        }
        print(response.notification.request.content.badge ?? "")
        completionHandler()
    }

    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler( [.banner, .sound, .badge, .list])
    }
}
