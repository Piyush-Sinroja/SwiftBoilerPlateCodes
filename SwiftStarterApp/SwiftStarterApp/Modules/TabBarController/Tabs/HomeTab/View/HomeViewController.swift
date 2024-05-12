//
//  HomeViewController.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/7/23.
//

import Amplify
import CoreData
import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties

    private var manager: UserManager = .init()

    // MARK: - IBOutlets

    @IBOutlet var welcomeNameLabel: UILabel! {
        didSet {
            welcomeNameLabel.font = .openSans(of: 20, in: .semiBold)
            welcomeNameLabel.textColor = .hex_000000_Black
        }
    }

    // MARK: - Initializers

    convenience init() {
        self.init()
        let prefferedLanguage = Localize.currentLanguage()
        let imageNmae = prefferedLanguage == Language.arebic.code ? "chevron.right" : "chevron.left"
        UINavigationBar.appearance().backIndicatorImage = UIImage(systemName: imageNmae)
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(systemName: imageNmae)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - View Life Cycle

extension HomeViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()

        FirebaseCrashlyticsUtils.setCustomValue(StorageService.shared.isUserConnected ?? false, forKey: GAConstant.CRASHLYTICS_USER_LOGGED)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension HomeViewController {
    private func setUI() {
        let userName = StorageService.shared.userName ?? ""
        let welcomeName = LocalizedKey.Welcome_Name.localizedFormat(userName.capitalized)
        welcomeNameLabel.text = "\(welcomeName)!"

//        getUserDetails()
        // fetchUserfromDataBase()
    }

    // Fetch User from CoreData
    private func fetchUserfromDataBase() {
        let uuid = UUID(uuidString: StorageService.shared.userID ?? "")
        let user = manager.fetchUser(byIdentifier: uuid ?? UUID())
        let welcomeName = LocalizedKey.Welcome_Name.localizedFormat(user?.username.capitalized ?? "")
        welcomeNameLabel.text = "\(welcomeName)!"

    }
    
    private func getUserDetails() {
        Task {
            do {
                self.setLoading(true)
                let userDetails = try await AwsAuthManager.shared.fetchAttributes()
                let username = userDetails.filter { $0.key == .preferredUsername }.first?.value ?? ""
                let welcomeName = LocalizedKey.Welcome_Name.localizedFormat(username.capitalized)
                welcomeNameLabel.text = "\(welcomeName)!"
                self.setLoading(false)
            } catch {
                print(error.localizedDescription)
                self.setLoading(false)
            }
        }
    }
}
