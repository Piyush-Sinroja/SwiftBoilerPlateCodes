//
//  UINavigationController+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/21/23.
//

import Foundation
import UIKit

// MARK: - UINavigationController Extension

extension UINavigationController {
  
  override open func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    /// Back Button Tinit Color
    UINavigationBar.appearance().tintColor = .black
    
    /// Hide Back Button Text
    navigationBar.topItem?.backButtonDisplayMode = .minimal
  }
}

public extension UINavigationController {
  
  /// BAck to spicefic vc in the stack
  ///
  /// - Parameters:
  ///   - type: UIViewController
  ///   - animated: animated
  func backTo<T: UIViewController>(_ type: T.Type, animated: Bool = true) {
    if let vc = viewControllers.first(where: { $0 is T }) {
      popToViewController(vc, animated: animated)
    }
  }
  
  /// making the nav bar with gradient image
  func updateImageWithGradient(colors: [CGColor]) {
    
    let navBarHeight = navigationBar.frame.size.height
    let statusBarHeight = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    let heightAdjustment: CGFloat = 2
    let gradientHeight = navBarHeight + statusBarHeight + heightAdjustment
    
    let bgImage = imageWithGradient(colors: colors,
                                    size: CGSize(width: UIScreen.main.bounds.size.width,
                                                 height: gradientHeight))
    guard let image = bgImage else { return }
    navigationBar.barTintColor = UIColor(patternImage: image)
  }
  
  /// Create an UIImage
  ///
  /// - Parameters:
  ///   - colors: Array of gradient colors
  ///   - size: CGSize
  /// - Returns: UIImage?
  private func imageWithGradient(colors: [CGColor],
                                 size: CGSize, locations: [NSNumber] = [0, 1],
                                 startPoint: CGPoint = CGPoint(x: 0.25, y: 0.5),
                                 endPoint: CGPoint = CGPoint(x: 0.75, y: 0.5),
                                 transform: CATransform3D = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1, c: -1, d: 0, tx: 1, ty: 0))) -> UIImage? {
    
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
    gradientLayer.colors = colors
    gradientLayer.locations = locations
    gradientLayer.bounds = view.bounds.insetBy(dx: -0.5 * size.width, dy: -0.5 * size.height)
    gradientLayer.startPoint = startPoint
    gradientLayer.endPoint = endPoint
    gradientLayer.position = self.view.center
    gradientLayer.transform = transform
    
    UIGraphicsBeginImageContext(gradientLayer.bounds.size)
    if let context = UIGraphicsGetCurrentContext() {
      gradientLayer.render(in: context)
    }
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
}
