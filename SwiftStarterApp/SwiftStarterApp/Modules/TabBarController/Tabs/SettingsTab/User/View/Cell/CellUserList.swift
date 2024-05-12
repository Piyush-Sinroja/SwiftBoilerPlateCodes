//
//  CellUserList.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/1/23.
//

import UIKit

class CellUserList: UITableViewCell {
    // MARK: - Outlets

    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var userEmailLabel: UILabel!

    // MARK: - SetUp

    func configure(_ item: UserDetails) {
        self.userNameLabel.text = item.name
        self.userEmailLabel.text = item.email
        self.userNameLabel.font = .openSans(of: 16, in: .bold)
        self.userNameLabel.textColor = UIColor.hex_3A3B3C_DarkGray
    }
}
