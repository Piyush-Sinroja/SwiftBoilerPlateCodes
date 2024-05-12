//
//  ExpandHeaderView.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/12/23.
//

import UIKit

class ExpandHeaderView: UITableViewHeaderFooterView {

  // MARK: - IBOutlets
  
  @IBOutlet weak var arrowImageView: UIImageView!
  @IBOutlet weak var categoryNameLabel: UILabel!

  // MARK: - Helper Method

  /// animate image
  /// - Parameter isExpanded: isExpanded bool value
  func animateImage(isExpanded: Bool) {
    UIView.animate(withDuration: 0.3, animations: {
      self.arrowImageView.transform = isExpanded ? CGAffineTransform(rotationAngle: .pi) : .identity
    })
  }
}
