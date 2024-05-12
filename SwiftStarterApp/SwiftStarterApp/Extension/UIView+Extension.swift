//
//  UIView+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/1/23.
//

import Foundation
import UIKit

// MARK: - Load Nib

extension UIView {
    class func fromNib<T>() -> T where T: UIView {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }

    func loadFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

protocol Identifiable {
    static var identifier: String { get }
}

extension Identifiable where Self: UIView {
    static var identifier: String {
        String(describing: self)
    }
}

extension UIView {
    /// roundCorners
    ///
    /// - Parameter cornerRadius: radius value
    func roundCorners(cornerRadius: CGFloat = 5.0) {
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
    }

    /// Adding round corners to a UIView | UIButton | UIImageView and all other UIKit elements
    ///
    /// - Parameters:
    ///   - corners: .topLeft | .topRight | .bottomLeft | .bottomRight
    ///   - radius: corner radius
    func roundCorners(corners: UIRectCorner = .allCorners, radius: CGFloat) {
      if #available(iOS 11.0, *) {
        layer.cornerRadius = radius
        guard !corners.contains(.allCorners) else { return }
        layer.maskedCorners = []
        if corners.contains(.topLeft) {
          layer.maskedCorners.insert(.layerMaxXMinYCorner)
        }
        if corners.contains(.topRight) {
          layer.maskedCorners.insert(.layerMinXMinYCorner)
        }
        if corners.contains(.bottomLeft) {
          layer.maskedCorners.insert(.layerMinXMaxYCorner)
        }
        if corners.contains(.bottomRight) {
          layer.maskedCorners.insert(.layerMaxXMaxYCorner)
        }
      } else {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.frame = bounds
        mask.path = path.cgPath
        layer.mask = mask
      }
    }

    /// This will set corner radius of View
    func roundView() {
        layer.cornerRadius = frame.size.width / 2
        layer.masksToBounds = true
    }

    /// take Screenshot
    /// - Returns: Snapshot image of view
    func takeScreenshot() -> UIImage? {
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        // And finally, get image
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()

        return image
    }

    /// Flip view horizontally.
    func flipX() {
        transform = CGAffineTransform(scaleX: -transform.a, y: transform.d)
    }

    /// Flip view vertically.
    func flipY() {
        transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
    }

    /// drop shadow with bezier path
    /// - Parameters:
    ///   - color: shadow color
    ///   - opacity: shadow opacity value
    ///   - offSet: shadow offset size
    ///   - radius: shadow radius value
    ///   - scale: bool value to scale or not
    func dropShadowWithBezierPath(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }

    /// set drop shadow
    /// - Parameters:
    ///   - color: shadow color
    ///   - opacity: shadow opecity
    ///   - offSet: shadow offset
    ///   - shadowRadius: shadow radius
    ///   - cornerRadius: corner radius value
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, shadowRadius: CGFloat = 1, cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.masksToBounds = false
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowColor = color.cgColor
    }

    /// add gradient layer
    /// - Parameters:
    ///   - colors: cg colors
    ///   - startPoint: gradient start point
    ///   - endPoint: gradient end point
    func addGradientLayer(colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint) {
        let mGradient = CAGradientLayer()
        mGradient.frame = self.bounds
        mGradient.startPoint = startPoint
        mGradient.endPoint = endPoint
        mGradient.colors = colors
        self.layer.addSublayer(mGradient)
    }

    func setImageTopRightAndBottomRightCorner(withRadius radius: CGFloat = 8) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }

    // Get All Subviews from Parent iOS: 13
    public func allSubViewsOf<T: UIView>(type: T.Type) -> [T] {
        var all = [T]()
        func getSubview(view: UIView) {
            if let wrapped = view as? T, wrapped != self {
                all.append(wrapped)
            }
            guard view.subviews.isEmpty else { return }
            view.subviews.forEach { getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }

    func fadeIn(completion: (() -> Void)? = nil) {
        alpha = 0
        isHidden = false
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }) { _ in
            completion?()
        }
    }

    func fadeOut(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { _ in
            self.isHidden = true
            completion?()
        }
    }

    /// global frame
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}

extension UIView {

  func allButtonSelect(_ select: Bool) {
    for view: UIView in self.subviews {
      if let button = view as? UIButton {
        button.isSelected = select
      } else {
        view.allButtonSelect(select)
      }
    }
  }

  func allButtonEnable(_ enable: Bool) {
    for view: UIView in self.subviews {
      if let button = view as? UIButton {
        button.isEnabled = enable
      } else {
        view.allButtonEnable(enable)
      }
    }
  }

}
