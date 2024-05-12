//
//  ContactBackupTableViewCell.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 23/11/23.
//

import UIKit

class ContactBackupTableViewCell: UITableViewCell {

    @IBOutlet weak var backupNameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model: VCardModel) {
        if let fileSize = model.fileUrl.fileSize() {
            backupNameLabel.text = "\(model.fileUrl.lastPathComponent) and Size: \(fileSize)"
        } else {
            backupNameLabel.text = "\(model.fileUrl.lastPathComponent)"
        }
    }
}
