//
//  CellRockets.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 1/2/24.
//

import SpaceXAPI
import UIKit

class CellRockets: UITableViewCell {
    // MARK: - IBOutlets

    @IBOutlet var nameLabel: UILabel! {
        didSet {
            self.nameLabel.font = .openSans(of: 16, in: .bold)
            self.nameLabel.textColor = UIColor.hex_3A3B3C_DarkGray
        }
    }

    @IBOutlet var descriptionLabel: UILabel! {
        didSet {
            self.descriptionLabel.font = .openSans(of: 12, in: .regular)
            self.descriptionLabel.textColor = UIColor.hex_3A3B3C_DarkGray
        }
    }
    
    @IBOutlet var heightLabel: UILabel! {
        didSet {
            self.heightLabel.font = .openSans(of: 14, in: .semiBold)
            self.heightLabel.textColor = UIColor.hex_3A3B3C_DarkGray
        }
    }

    @IBOutlet var wieghtLabel: UILabel! {
        didSet {
            self.wieghtLabel.font = .openSans(of: 14, in: .semiBold)
            self.wieghtLabel.textColor = UIColor.hex_3A3B3C_DarkGray
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - SetUp

    func configure(_ item: RocketsQuery.Data.Rocket) {
        self.nameLabel.text = "Name: \(item.name ?? "")"

        self.descriptionLabel.text = "Description: \(item.description ?? "")"

//        self.heightLabel.text = "Height: \(item.height?.meters ?? 0.0)"

//        self.wieghtLabel.text = "Weight: \(item.mass?.kg ?? 0)"
    }
}
