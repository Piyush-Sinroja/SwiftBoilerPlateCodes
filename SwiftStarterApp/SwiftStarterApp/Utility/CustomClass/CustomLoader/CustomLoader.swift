//
//  CustomLoader.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/1/23.
//

import UIKit

public class CustomLoader {
    public static let shared = CustomLoader()
    var blurImg = UIImageView()
    var indicator = UIActivityIndicatorView()

    private init() {
        blurImg.frame = UIScreen.main.bounds
        blurImg.backgroundColor = UIColor.black
        blurImg.isUserInteractionEnabled = true
        blurImg.alpha = 0.5
        indicator.style = .large
        indicator.center = blurImg.center
        indicator.startAnimating()
        indicator.color = .red
    }

    func showIndicator() {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.addSubview(self.blurImg)
            UIApplication.shared.keyWindow?.addSubview(self.indicator)
        }
    }

    func hideIndicator() {
        DispatchQueue.main.async {
            self.blurImg.removeFromSuperview()
            self.indicator.removeFromSuperview()
        }
    }
}
