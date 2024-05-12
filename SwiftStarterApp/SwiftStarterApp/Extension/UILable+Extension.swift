//
//  UILable+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/22/23.
//

import Foundation
import UIKit

// MARK: - Localizable Label

//extension UILabel {
//    override open func awakeFromNib() {
//        super.awakeFromNib()
//        let prefferedLanguage = Localize.currentLanguage()
//        if prefferedLanguage == Language.arebic.code {
//            if prefferedLanguage == Language.arebic.code {
//                self.textAlignment = .right
//            } else {
//                self.textAlignment = .left
//            }
//        }
//    }
//}

extension UILabel {

  func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

    guard let labelText = self.text else { return }

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing
    paragraphStyle.lineHeightMultiple = lineHeightMultiple

    let attributedString: NSMutableAttributedString
    if let labelattributedText = self.attributedText {
      attributedString = NSMutableAttributedString(attributedString: labelattributedText)
    } else {
      attributedString = NSMutableAttributedString(string: labelText)
    }

    let dicAttributes = [NSAttributedString.Key.paragraphStyle: paragraphStyle]

    attributedString.addAttributes(dicAttributes, range: NSMakeRange(0, attributedString.length))
    self.attributedText = attributedString
  }

}
