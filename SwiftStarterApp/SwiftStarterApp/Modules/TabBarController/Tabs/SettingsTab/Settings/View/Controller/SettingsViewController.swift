//
//  SetttingsViewController.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/7/23.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - Properties

    var viewModel: SettingsViewModel = .init()

    let availableLanguages = Localize.availableLanguages()

    // MARK: - Outlets

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.registerCell(type: CellSettings.self)
        }
    }

    @IBOutlet var logoutButton: ReusableButton! {
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

extension SettingsViewController {
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

extension SettingsViewController {
    func logoutButtonAction() {
        Task {
            await AwsAuthManager.shared.signOutLocally()
            await AwsAuthManager.shared.signOutGlobally()
        }
        StorageService.shared.isUserConnected = false
        FirebaseCrashlyticsUtils.setCustomValue(StorageService.shared.isUserConnected ?? false, forKey: GAConstant.CRASHLYTICS_USER_LOGGED)
        AppConfiguration.shared.setRootVC()
    }
}

extension SettingsViewController {
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
                    self.showAlert(withTitle: "Error", andMessage: "\(error?.errorDescription ?? "")")
                }
            }
        }
    }
}

// MARK: - TableView DataSource & Delegate

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
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
        guard let item = SettingMenuItems(rawValue: viewModel.items[indexPath.row].title) else { return }
        self.navigate(to: item)
    }

    private func navigate(to itemType: SettingMenuItems) {
        switch itemType {
        case .UserList:
            let vc = UserListViewController.instantiate(appStoryboard: .main)
            self.navigationController?.pushViewController(vc, animated: true)
        case .UserListbyAlamofire:
            let userListViewController: UserListViewController = .instantiate(appStoryboard: .main)
            userListViewController.isUsingAlamofire = true
            self.navigationController?.pushViewController(userListViewController, animated: true)
        case .FetchUserWithID:
            let userListViewController: UserListViewController = .instantiate(appStoryboard: .main)
            userListViewController.fetchWithUserID = true
            self.navigationController?.pushViewController(userListViewController, animated: true)
        case .UserListUsingAsyncAwait:
            let vc: UserListViewController = UserListViewController.instantiate(appStoryboard: .main)
            vc.isUsingAsyncAwait = true
            self.navigationController?.pushViewController(vc, animated: true)
        case .Contacts:
            let contactListVC: ContactListVC = .instantiate(appStoryboard: .setting)
            self.navigationController?.pushViewController(contactListVC, animated: true)
        case .ChangedLanguage:
            changeLangugae()
        case .Locations:
            let vc: LocationViewController = .instantiate(appStoryboard: .locations)
            vc.name = "Locations"
            self.navigationController?.pushViewController(vc, animated: true)
        case .ImageSelection:
            let vc = ImagePickerViewController.instantiate(appStoryboard: .setting)
            self.navigationController?.pushViewController(vc, animated: true)
        case .CustomAlert:
            showALert()
        case .ZoomImage:
            let zoomImageVC = ZoomImageVC.instantiate(appStoryboard: .setting)
            self.navigationController?.pushViewController(zoomImageVC, animated: true)
            case .DatePicker:
                let datePickerVC: DatePickerVC = DatePickerVC.instantiate(appStoryboard: .setting)
                datePickerVC.modalPresentationStyle = .overFullScreen
                datePickerVC.selectButtonTitle = "Ok"
                datePickerVC.cancelButtonTitle = "Cancel"
                datePickerVC.maximumDate = Date()
                datePickerVC.datePickerType = .date

                var components = DateComponents()
                components.year = -100
                let minDate = Calendar.current.date(byAdding: components, to: Date())
                datePickerVC.minimumDate = minDate
                datePickerVC.delegate = self
                present(datePickerVC, animated: false, completion: nil)

            case .DropDown:
                let dropDownVC = DropDownVC.instantiate(appStoryboard: .setting)
                self.navigationController?.pushViewController(dropDownVC, animated: true)
            case .GraphQLApi:
                let dropDownVC = GraphQLDemoViewController.instantiate(appStoryboard: .setting)
                self.navigationController?.pushViewController(dropDownVC, animated: true)
        }
    }
}

extension SettingsViewController {
    // MARK: - Change Language

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

    // MARK: Show Custom Alert

    private func showALert() {
        let vc: AlertPopUpViewController = AlertPopUpViewController.instantiate(appStoryboard: .Common)
        vc.titleMessage = "Title".translated.uppercased()
        vc.descriptionMessage = "Description".translated
        vc.imageName = "menucard"
        vc.okayButtonTapped = {
            Logger.log("Okay Button Pressed")
        }
        vc.cancelButtonTapped = {
            Logger.log("Cancel Button Pressed")
        }
        vc.closeButtonTapped = {
            Logger.log("Close Button Pressed")
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController?.present(vc, animated: true)
    }
}

// MARK: - DatePickerDelegate
extension SettingsViewController: DatePickerDelegate {
    func datePickerDidSelectDate(_ date: Date, mode: UIDatePicker.Mode) {
        if mode == .date {
            Logger.log("UIDatePicker date: \(date)")
        }
    }
}
