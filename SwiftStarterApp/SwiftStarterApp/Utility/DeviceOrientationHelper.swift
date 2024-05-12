//
//  DeviceOrientationHelper.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 07/12/23.
//

import Foundation
import UIKit

struct DeviceOrientationHelper {
  static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation) {
    if let delegate = UIApplication.shared.delegate as? AppDelegate {
      delegate.orientationLock = orientation
    }
    UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
  }
}
