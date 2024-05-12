//
//  UITextField+Extensions.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/8/23.
//

import Foundation
import UIKit

// MARK: - Validation

extension UITextField {
    func validatedText(validationType: ValidatorType) throws -> String {
        let validator = ValidatorFactory.validatorFor(type: validationType)
        return try validator.validated(self.text!)
    }
    
    func validatedTextConfirPassword(validationType: ValidatorType, password: String, confirmPassword: String) throws -> String {
        let validator = ValidatorFactory.validatorFor(type: validationType)
        return try validator.validated(password, confirmPassword)
    }
}

// MARK: - Password Hide/Show

extension UITextField {
    fileprivate func setPasswordToggleImage(_ button: UIButton) {
        if isSecureTextEntry {
            button.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        }
    }

    func enablePasswordToggle() {
        self.isSecureTextEntry = true
        let button = UIButton(type: .custom)
        button.configuration = createConfig()
        button.tintColor = .black
        button.addTarget(self, action: #selector(self.togglePasswordView), for: .touchUpInside)
        setPasswordToggleImage(button)
        self.rightView = button
        self.rightViewMode = .always
    }

    func createConfig() -> UIButton.Configuration {
        var config = UIButton.Configuration.plain()
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20)
        return config
    }

    @objc func togglePasswordView(_ sender: Any) {
        self.isSecureTextEntry = !self.isSecureTextEntry
        setPasswordToggleImage(sender as! UIButton)
    }
}

// MARK: - Localization UITextField
extension UITextField {
open override func awakeFromNib() {
        super.awakeFromNib()
    
        let prefferedLanguage = Localize.currentLanguage()
        if prefferedLanguage == Language.arebic.code {
            if textAlignment == .natural {
                self.textAlignment = .right
                UIView.appearance().semanticContentAttribute = .forceRightToLeft

            } else {
                self.textAlignment = .left
                UIView.appearance().semanticContentAttribute = .forceLeftToRight

            }
        }
    }
}

// MARK: Date Picker

extension UITextField {
    func datePicker<T>(target: T, doneAction: Selector,
                       cancelAction: Selector,
                       datePickerMode: UIDatePicker.Mode = .date,
                       preferredDatePickerStyle: UIDatePickerStyle = .wheels) {
        let screenWidth = UIScreen.main.bounds.width
        func buttonItem(withSystemItemStyle style: UIBarButtonItem.SystemItem) -> UIBarButtonItem {
            let buttonTarget = style == .flexibleSpace ? nil : target
            let action: Selector? = {
                switch style {
                case .cancel:
                    return cancelAction
                case .done:
                    return doneAction
                default:
                    return nil
                }
            }()

            let barButtonItem = UIBarButtonItem(barButtonSystemItem: style, target: buttonTarget, action: action)

            return barButtonItem
        }

        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = datePickerMode
        datePicker.preferredDatePickerStyle = preferredDatePickerStyle
        self.inputView = datePicker

        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        toolBar.setItems([buttonItem(withSystemItemStyle: .cancel),
                          buttonItem(withSystemItemStyle: .flexibleSpace),
                          buttonItem(withSystemItemStyle: .done)],
                         animated: true)
        self.inputAccessoryView = toolBar
    }
}

public extension UITextField {

  /// Adding an image to the left of the textFeild.
  ///
  /// - Parameters:
  ///   - image: image to use .. best to use PDF image.
  ///   - color: image color
  func left(image: UIImage?, color: UIColor = .black, width: CGFloat = 20, height: CGFloat = 20) {
    if let image = image {
      leftViewMode = UITextField.ViewMode.always
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
      imageView.contentMode = .scaleAspectFit
      imageView.image = image
      imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
      imageView.tintColor = color
      leftView = imageView
    } else {
      leftViewMode = UITextField.ViewMode.never
      leftView = nil
    }
  }

  /// Adding an image to the right of the textFeild
  ///
  /// - Parameters:
  ///   - image: image to use .. best to use PDF image.
  ///   - color: image color
  func right(image: UIImage?, color: UIColor = .black, width: CGFloat = 20, height: CGFloat = 20) {
    if let image = image {
      rightViewMode = UITextField.ViewMode.always
      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
      imageView.contentMode = .scaleAspectFit
      imageView.image = image
      imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
      imageView.tintColor = color
      rightView = imageView
    } else {
      rightViewMode = UITextField.ViewMode.never
      rightView = nil
    }
  }

  /// Add left padding to the text in textfield
  func addLeftTextPadding(_ blankSize: CGFloat) {
    let leftView = UIView()
    leftView.frame = CGRect(x: 0, y: 0, width: blankSize, height: frame.height)
    self.leftView = leftView
    self.leftViewMode = UITextField.ViewMode.always
  }

  /// Set placeholder text color.
  ///
  /// - Parameter color: placeholder text color.
  func setPlaceHolderTextColor(_ color: UIColor) {
    self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: color])
  }

  /// Set placeholder text and its color
  func placeholderTextAndColor(text value: String, color: UIColor = .red) {
    self.attributedPlaceholder = NSAttributedString(string: value, attributes: [ NSAttributedString.Key.foregroundColor: color])
  }

  /// Sets bottom border
  ///
  /// - Parameters:
  ///     - color: Border color
  ///     - borderHeight: Border height
  func setBottomBorder(withColor color: UIColor, borderHeight: CGFloat) {
    borderStyle = .none
    layer.backgroundColor = UIColor.white.cgColor

    layer.masksToBounds = false
    layer.shadowColor = color.cgColor
    layer.shadowOffset = CGSize(width: 0.0, height: borderHeight)
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 0.0
  }
}
