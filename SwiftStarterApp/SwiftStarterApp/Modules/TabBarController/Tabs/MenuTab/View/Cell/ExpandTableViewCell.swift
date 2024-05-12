//
//  ExpandTableViewCell.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/12/23.
//

import UIKit

class ExpandTableViewCell: UITableViewCell {

  // MARK: - IBOutlets

  @IBOutlet weak var nameLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  // MARK: - Configure Cell

  /// configure cell with subdetails
  /// - Parameter subDetails: MenuSubDetails
  func configureCell(subDetails: MenuSubDetails) {
    nameLabel.text = subDetails.name
  }
}
