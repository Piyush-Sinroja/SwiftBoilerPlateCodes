//
//  UIViewController+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/1/23.
//

import UIKit

// MARK: Show/Hide Loading

extension UIViewController {
    func setLoading(_ loading: Bool) {
        if loading {
            CustomLoader.shared.showIndicator()
        } else {
            CustomLoader.shared.hideIndicator()
        }
    }
}

// MARK: UIViewController Extension

extension UIViewController {
    func showAlert(withTitle title: String? = nil, andMessage message: String, okButtonTitle: String = Constant.Button.okButton, okAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        // Handling OK action
        let okAction = UIAlertAction(title: okButtonTitle, style: .default) { _ in
            okAction?()
        }

        // Adding action buttons to the alert controller
        alert.addAction(okAction)

        DispatchQueue.main.async { [weak self] in
            // Presenting alert controller
            self?.present(alert, animated: true, completion: nil)
        }
    }

    func showAlert(withTitle title: String = Constant.Common.appTitle, andMessage message: String, okButtonTitle: String = Constant.Button.okButton, cancelButtonTitle: String = Constant.Button.cancelButton, okAction: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)

        let okAction = UIAlertAction(title: okButtonTitle, style: .default) { _ in
            okAction?()
        }

        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel) { _ in
            cancelAction?()
        }

        alert.addAction(okAction)
        alert.addAction(cancelAction)

        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: Instantiate ViewController with Storyboard

extension UIViewController {
    class func instantiate<T: UIViewController>(appStoryboard: Storyboard) -> T {
        let storyboard = UIStoryboard(name: appStoryboard.rawValue, bundle: nil)
        let identifier = String(describing: self)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(identifier) ")
        }
        return viewController
    }
}

// MARK: - Show/Hide Navigationbar

extension UIViewController {
    func hideNavigationBar(animated: Bool) {
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func showNavigationBar(animated: Bool) {
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

public extension UIViewController {

  ///  Returns Navigation Bar's height
  var navigationBarHeight: CGFloat {
    if let me = self as? UINavigationController, let visibleViewController = me.visibleViewController {
      return visibleViewController.navigationBarHeight
    }
    if let nav = self.navigationController {
      return nav.navigationBar.frame.size.height
    }
    return 0
  }

    /// Return top bar height
    var topbarHeight: CGFloat {
        let statusBarHeight = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        return navigationBarHeight + statusBarHeight
    }

  /// changing the back bar button title and color for subViewControllers
  ///
  /// - Parameter stringToUse: back bar button title
  func setBackButtonTitle(_ stringToUse: String) {
    let titleToSet = stringToUse
    let bacButton = UIBarButtonItem(title: titleToSet, style: .plain, target: nil, action: nil)
    navigationItem.backBarButtonItem = bacButton
  }

  /// Show any viewController as a root
  ///
  /// - Parameters:
  ///   - flag: animation flag
  ///   - completion: completion
  func show(animated flag: Bool, completion: (() -> Void)? = nil) {
    let window = UIWindow(frame: UIScreen.main.bounds)
    window.rootViewController = UIViewController()
    window.windowLevel = UIWindow.Level.alert
    window.makeKeyAndVisible()
    window.tintColor = .red
    window.rootViewController?.present(self, animated: flag, completion: completion)
  }

  /// Setting the navigation title and tab bar title
  ///
  /// - Parameters:
  ///   - navigationTitle: Navigation title
  ///   - tabBarTitle: TabBar title
  func setTitles(navigationTitle: String? = nil, tabBarTitle: String? = nil) {
    // Order is important here!
    if let tabBarTitle = tabBarTitle {
      title = tabBarTitle
    }
    if let navigationTitle = navigationTitle {
      navigationItem.title = navigationTitle
    }
  }

  /// Setting the backBarButtonItem for the next screen to "" to hide it.
  func hideBackButtonTitle() {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }

  /// Removing the shadow image from the navigationBar
  func hideShadowImageFromNavigation() {
    navigationController?.navigationBar.shadowImage = UIImage()
  }

  /// Adding a tap gesture recognizer to hide the keyboard
  func addKeyboardHidingGesture() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  /// selector method for addKeyboardHidingGesture()
  @objc func dismissKeyboard() {
    view.endEditing(true)
  }

  /// Presents a view controller modally.
  func presentThis(_ vc: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
    present(vc, animated: animated, completion: completion)
  }

  /// Pushes a view controller onto the receiver’s stack and updates the display.
  func pushThis(_ vc: UIViewController, animated: Bool = true) {
    navigationController?.pushViewController(vc, animated: animated)
  }

  /// Dismisses the view controller that was presented modally by the view controller.
  func dismissThis(animated: Bool = true, completion: (() -> Void)? = nil) {
    dismiss(animated: animated, completion: completion)
  }

  /// Pops the top view controller from the navigation stack and updates the display.
  func pop(animated: Bool = true) {
    navigationController?.popViewController(animated: animated)
  }

  /// Pops all the view controllers on the stack except the root view controller and updates the display.
  func popToRoot(animated: Bool = true) {
    navigationController?.popToRootViewController(animated: animated)
  }

  /// Animating dictionary of constrints
  ///
  /// - Parameters:
  ///   - constraints: NSLayoutConstraint and CGFloat
  ///   - duration: TimeInterval for the animation, default is 0.3
  func animateConstrints(constraints: [NSLayoutConstraint: CGFloat], duration: TimeInterval = 0.3) {
    UIView.animate(withDuration: duration) {
      for (constraint, value) in constraints {
        constraint.constant = value
      }
      self.view.layoutIfNeeded()
    }
  }
}
