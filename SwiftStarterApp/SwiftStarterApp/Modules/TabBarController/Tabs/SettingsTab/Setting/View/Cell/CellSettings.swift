//
//  CellSettings.swift
//  SwiftStarterApp
//
//  Created by Pratik Panchal on 11/9/23.
//

import UIKit

class CellSettings: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!

    // MARK: - SetUp

    func configure(_ item: SettingsModel) {
        self.titleLabel.text = item.title
        self.titleLabel.font = .openSans(of: 16, in: .regular)
        self.titleLabel.textColor = UIColor.hex_3A3B3C_DarkGray
    }
}
