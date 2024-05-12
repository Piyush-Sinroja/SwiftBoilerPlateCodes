//
//  SetttingsViewController.swift
//  SwiftStarterApp
//
//  Created by Pratik Panchal on 11/7/23.
//

import UIKit

class SetttingsViewController: UIViewController {
    // MARK: - Properties
    
    var viewModel: SettingsViewModel = .init()
    
    let availableLanguages = Localize.availableLanguages()
    
    // MARK: - Outlets

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.registerCell(type: CellSettings.self)
        }
    }
    @IBOutlet weak var logoutButton: ReusableButton! {
        didSet {
            logoutButton.viewModel = ReusableButtonViewModel(
                title: LocalizedKey.Logout.localized(),
                titleColor: .white,
                backgroundColor: .black,
                cornerRadius: 10,
                font: UIFont.openSans(of: 16, in: .semiBold)
            )
            logoutButton.tapped = { [weak self] in
                self?.logoutButtonAction()
            }
        }
    }
}

// MARK: - View Life Cycle

extension SetttingsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.observeEvent()
        self.fetchMenuItemsList()
    }

    func fetchMenuItemsList() {
        viewModel.fetchMenuItemsList()
    }
}

// MARK: - Actions
extension SetttingsViewController {
        
    func logoutButtonAction() {
        StorageService.shared.isUserConnected = false
        AppConfiguration.shared.setRootVC()
    }
}

extension SetttingsViewController {
    func observeEvent() {
        viewModel.eventHandler = { state in
            switch state {
            case .loading:
                self.setLoading(true)
            case .success:
                DispatchQueue.main.async {
                    self.setLoading(false)
                    self.tableView.reloadData()
                }
            case .failed(let error):
                self.setLoading(false)
                DispatchQueue.main.async {
                    self.showAlert(withTitle: "Error", andMessage: "\(error?.description ?? "")")
                }
            }
        }
    }
}

// MARK: - TableView DataSource & Delegate

extension SetttingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: CellSettings.self, for: indexPath) as? CellSettings else {
            return UITableViewCell()
        }
        let item = viewModel.items[indexPath.row]
        cell.configure(item)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigate(didSelectRowAt: indexPath)
    }
    
    func navigate(didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
<<<<<<< HEAD:SwiftStarterApp/SwiftStarterApp/Modules/TabBarController/Tabs/SettingsTab/Setting/View/Controller/SetttingsViewController.swift
            case 0:
                let vc = UserListViewController.instantiate(appStoryboard: .main)
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                if let userListVc = UserListViewController.instantiate(appStoryboard: .main) as? UserListViewController {
                    userListVc.isUsingAlamofire = true
                    self.navigationController?.pushViewController(userListVc, animated: true)
                }
            case 2:
                if let contactListVC = ContactListVC.instantiate(appStoryboard: .setting) as? ContactListVC {
                    self.navigationController?.pushViewController(contactListVC, animated: true)
                }
            case 3:
                changeLangugae()
            default:
                break
=======
        case 0:
            let vc = UserListViewController.instantiate(appStoryboard: .main)
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            changeLangugae()
        case 3:
            let vc: LocationViewController = LocationViewController.instantiate(appStoryboard: .locations)
            vc.name = "Locations"
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            break
>>>>>>> 18cd9149aeaa4609cab4176703f6253534afd972:SwiftStarterApp/SwiftStarterApp/Modules/TabBarController/Tabs/SettingsTab/Settings/View/Controller/SetttingsViewController.swift
        }
    }
}

extension SetttingsViewController {
    func changeLangugae() {
        let actionSheet = UIAlertController(title: nil, message: "Switch Language", preferredStyle: UIAlertController.Style.actionSheet)
        for language in availableLanguages {
            let displayName = Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(title: displayName, style: .default, handler: { (_: UIAlertAction!) in
                Localize.setCurrentLanguage(language)
                AppConfiguration.shared.setRootVC()
            })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (_: UIAlertAction) in
        })
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
}
