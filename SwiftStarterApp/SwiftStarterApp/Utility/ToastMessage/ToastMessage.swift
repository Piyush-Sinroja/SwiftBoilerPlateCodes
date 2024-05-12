//
//  ToastMessage.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/29/23.
//

import Foundation
import UIKit

extension UIViewController {
    func toastMessage(_ message: String) {
        let messageLbl = UILabel()
        guard let window = UIApplication.shared.keyWindow else { return }
        messageLbl.removeFromSuperview()
        messageLbl.text = message
        messageLbl.textAlignment = .center
        messageLbl.font = .openSans(of: 18, in: .regular)
        messageLbl.textColor = .white
        messageLbl.backgroundColor = UIColor(white: 0, alpha: 0.9)

        let textSize: CGSize = messageLbl.intrinsicContentSize
        let labelWidth = min(textSize.width, window.frame.width - 40)

        messageLbl.frame = CGRect(x: 20, y: window.frame.height - 120, width: labelWidth + 60, height: textSize.height + 30)
        messageLbl.center.x = window.center.x
        messageLbl.layer.cornerRadius = messageLbl.frame.height / 2
        messageLbl.layer.masksToBounds = true
        window.addSubview(messageLbl)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 1, animations: {
                messageLbl.alpha = 0
            }) { _ in
                messageLbl.removeFromSuperview()
            }
        }
    }
}
