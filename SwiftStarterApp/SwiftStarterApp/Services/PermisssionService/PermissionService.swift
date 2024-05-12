//
//  PermissionService.swift
//  Spring
//
//  Created by Piyush Sinroja on 01/11/23.
//

import UIKit
import AVFoundation
import Photos

class PermissionService: NSObject {

    static var shared = PermissionService()

    private override init() { }

    // MARK: - MicroPhone Permission
    /// check microphone permission
    /// - Parameter completion: completion handler
    func checkMicroPhonePermission(completion: @escaping (_ permissionGranted: Bool) -> Void) {
        DispatchQueue.main.async {
            let permissionStatus = AVAudioSession.sharedInstance().recordPermission

            switch permissionStatus {
                case .granted:
                    // Record permission already granted.
                    completion(true)
                case .denied:
                    // Record permission denied.
                    completion(false)
                case .undetermined:
                    // Requesting record permission.
                    // Optional: pop up app dialog to let the users know if they want to request.
                    AVAudioSession.sharedInstance().requestRecordPermission { granted in completion(granted) }
                default:
                    completion(false)
            }
        }
    }

    /// microphone permission alert
    /// - Parameter vc: An object that manages a view hierarchy for your UIKit app.
    func microphonePermissionPopup(vc: UIViewController?) {
        let alertController = UIAlertController(title: Constant.Permission.microphonePermissionTitle, message: Constant.Permission.microphonePermissionMsg, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: Constant.Button.cancelButton, style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: Constant.Button.settings, style: .default) { [weak self] _ in
            self?.gotoAppSettings()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        DispatchQueue.main.async {
            vc?.present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - Camera Permission

    /// check camera access
    /// - Parameter completion: completion handler
    func checkCameraAccess(completion: @escaping (_ cameraPermissionGranted: Bool) -> Void) {
        DispatchQueue.main.async {
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .denied:
                    Logger.log("Denied, request permission from settings")
                    completion(false)
            case .restricted:
                    Logger.log("Restricted, device owner must approve")
                    completion(false)
            case .authorized:
                    Logger.log("Authorized, proceed")
                    completion(true)
            case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) { success in
                        if success {
                            completion(true)
                            Logger.log("Permission granted, proceed")
                        } else {
                            completion(false)
                            Logger.log("Permission denied")
                        }
                    }
            @unknown default:
                    completion(false)
            }
        }
    }

    /// present camera settings
    /// - Parameter vc: An object that manages a view hierarchy for your UIKit app.
    func presentCameraSettings(vc: UIViewController?) {
        let alertController = UIAlertController(title: Constant.Permission.cameraPermissionTitle,
                                                message: Constant.Permission.cameraPermissionMsg,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: Constant.Button.skip, style: .default))
        alertController.addAction(UIAlertAction(title: Constant.Button.settings, style: .default) {  [weak self] _ in
            self?.gotoAppSettings()
        })

        DispatchQueue.main.async {
            vc?.present(alertController, animated: true, completion: nil)
        }
    }

    // MARK: - Photos Permission
    /// check photo library permission
    /// - Parameter completion: completion handler
    func checkPhotoLibraryPermission(completion: @escaping (_ permissionGranted: Bool) -> Void) {
        DispatchQueue.main.async {
            let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .authorized {
                completion(true)
            } else {
                // Request permission to access photo library
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
                    DispatchQueue.main.async {
                        switch status {
                            case .authorized:
                                completion(true)
                            case .limited:
                                completion(true)
                            case .restricted:
                                completion(false)
                            case .denied:
                                completion(false)
                            case .notDetermined:
                                completion(false)
                            default:
                                completion(false)
                        }
                    }
                }
            }
        }
    }

    /// show notification permission alert
    /// - Parameter vc: An object that manages a view hierarchy for your UIKit app.
    func showNotificationPermissionAlert(vc: UIViewController) {
        let alert = UIAlertController(title: Constant.Permission.notificationPermissionTitle, message: Constant.Permission.notificationPermissionMsg, preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: Constant.Button.skip, style: .default, handler: nil)
        let settingsAction = UIAlertAction(title: Constant.Button.settings, style: .default) { [weak self](_) in
            self?.gotoAppSettings()
        }
        alert.addAction(cancelAction)
        alert.addAction(settingsAction)
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
    }

    /// go to app settings
    func gotoAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (_) in })
        }
    }
}
