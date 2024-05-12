//
//  ProfileViewController.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/7/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: -
    let viewModel: ProfileViewModel = .init()

    @IBOutlet weak var userNameLabel: UILabel! {
        didSet {
            userNameLabel.font = .openSans(of: 20, in: .semiBold)
        }
    }
    
    @IBOutlet weak var emailLabel: UILabel! {
        didSet {
            emailLabel.font = .openSans(of: 16, in: .regular)
        }
    }
    
    @IBOutlet weak var profileBackGroundImageView: UIImageView! {
        didSet {
            profileBackGroundImageView.contentMode = .scaleToFill

        }
    }
        
    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
           // self.updateUser()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUserProfileFromDatabase()
    }
}

extension ProfileViewController {
    
    func fetchUserProfileFromDatabase() {
        Task {
            guard let user = viewModel.fetchUserProfile() else { return }
            self.profileImageView.image = UIImage(data: user.profilePic ?? Data())
            self.userNameLabel.text = user.username
            self.emailLabel.text = user.email
            ImageDownloader.shared.setImageWithKingfisher(imgPath: "https://picsum.photos/200", imgView: self.profileBackGroundImageView, placeHolderImage: nil)
        }
    }
    
    func updateUser() {
        guard var user = viewModel.fetchUserProfile() else { return }
        user.username = "Piyush"
        user.email = "piyush@gmail.com"
        user.dob = "01/01/0000"

        viewModel.updateUser(user: user)
        fetchUserProfileFromDatabase()
    }
}
