//
//  UIImageView+Extension.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/21/23.
//

import Foundation
import UIKit

// MARK: - Localization UIImageView
extension UIImageView {
    open override func awakeFromNib() {
        super.awakeFromNib()
        let prefferedLanguage = Localize.currentLanguage()
        if prefferedLanguage == Language.arebic.code {
            self.transform = CGAffineTransformMakeScale(-1, 1)
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            self.transform = CGAffineTransformMakeScale(1.0, 1.0)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
}
