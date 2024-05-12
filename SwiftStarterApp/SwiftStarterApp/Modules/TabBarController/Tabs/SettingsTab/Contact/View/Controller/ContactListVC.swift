//
//  ContactListVC.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 22/11/23.
//

import UIKit

class ContactListVC: UIViewController {

    // MARK: - Variables

    var contactViewModel: ContactViewModel = .init()

    // MARK: - IBOutlets

    @IBOutlet weak var tblContact: UITableView! {
        didSet {
            tblContact.registerCell(type: ContactTableViewCell.self)
        }
    }

    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllContact()
    }

    // MARK: - SetupView

    func setupView() {
        let export = UIBarButtonItem(title: "Export", style: .plain, target: self, action: #selector(exportButtonAction))
        let Import = UIBarButtonItem(title: "Import", style: .plain, target: self, action: #selector(importButtonAction))
        navigationItem.leftBarButtonItem = export
        navigationItem.rightBarButtonItem = Import
    }

    // MARK: - Button Actions

    /// export button action
    @objc func exportButtonAction() {
        exportContact()
    }

    /// import button action
    @objc func importButtonAction() {
        if let contactBackupVC = ContactBackupVC.instantiate(appStoryboard: .setting) as? ContactBackupVC {
            self.navigationController?.pushViewController(contactBackupVC, animated: true)
        }
    }

    // MARK: - Get Contacts

    /// get all phone contacts
    func getAllContact() {
        contactViewModel.getAllContact {[weak self] isGranted in
            guard isGranted else {
                // open setting for contact permission
                return
            }
            self?.tblContact.reloadData()
        }
    }

    // MARK: - Delete Contact

    func deleteContact(index: Int) {
        contactViewModel.deleteContact(for: index) { [weak self] isGranted in
            guard isGranted else {
                self?.openSetting()
                return
            }
            self?.tblContact.reloadData()
        }
    }

    // MARK: - Export Contacts

    /// export contacts and create file url
    func exportContact() {

        let arrSelectedContact = contactViewModel.arrContactList

        guard !arrSelectedContact.isEmpty else {
            return
        }

        contactViewModel.exportContact(contacts: arrSelectedContact.map({ $0.contact })) { [weak self] fileUrl, isGranted in
            guard isGranted else {
                self?.openSetting()
                return
            }
            guard let url = fileUrl else {
                return
            }
            Logger.log("export contacts url: \(url)")
            if let contactBackupVC = ContactBackupVC.instantiate(appStoryboard: .setting) as? ContactBackupVC {
                self?.navigationController?.pushViewController(contactBackupVC, animated: true)
            }
        }
    }

    // MARK: - Helper Methods

    /// open setting
    func openSetting() {
        let message = "App needs permission to access your contacts.\nPlease go to Settings -> Privacy -> Contacts, then turn on."
        showAlert(withTitle: "", andMessage: message, okAction: {
            if let url = NSURL(string: UIApplication.openSettingsURLString) as URL?, UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }, cancelAction: nil)
    }
}

// MARK: - TableView DataSource

extension ContactListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactViewModel.arrContactList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: ContactTableViewCell.self, for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(contactModel: contactViewModel.arrContactList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - TableView Delegate
extension ContactListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteContact(index: indexPath.row)
        }
    }
}
