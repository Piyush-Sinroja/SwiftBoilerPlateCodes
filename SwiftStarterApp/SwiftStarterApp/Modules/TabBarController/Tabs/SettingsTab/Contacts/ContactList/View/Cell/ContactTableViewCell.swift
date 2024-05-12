//
//  ContactTableViewCell.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 22/11/23.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    // MARK: - IBOutlet

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - configure cell

    func configure(contactModel: ContactModel) {
        nameLabel.text = contactModel.contact.givenName + " " + contactModel.contact.familyName
    }
}
