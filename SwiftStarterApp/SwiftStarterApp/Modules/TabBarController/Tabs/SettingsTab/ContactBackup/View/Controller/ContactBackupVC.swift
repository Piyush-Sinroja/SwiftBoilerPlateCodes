//
//  ContactBackupVC.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 23/11/23.
//

import UIKit

class ContactBackupVC: UIViewController {

    // MARK: - Variables

    var contactBackupViewModel: ContactBackupViewModel = .init()
    var arrBackupList: [VCardModel] = []

    // MARK: - IBOutlet
    @IBOutlet weak var tblContactBackup: UITableView! {
        didSet {
            tblContactBackup.registerCell(type: ContactBackupTableViewCell.self)
        }
    }

    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        contactBackupViewModel.getAllContactBackupFilesFromDocumentDir {[weak self] in
            self?.tblContactBackup.reloadData()
        }
    }

    // MARK: - Restore and Import Contacts

    /// restore and import contacts
    /// - Parameter url: contacts fileurl
    func restoreAndImportContacts(from url: URL) {
        contactBackupViewModel.restoreContacts(from: url) { [weak self] arrContactList in

            guard !arrContactList.isEmpty else {
                return
            }
            self?.contactBackupViewModel.importContacts(contacts: arrContactList) { [weak self] indexValue, isGranted in

                Logger.log(isGranted)

                DispatchQueue.main.async {
                    // print("\(index) contact imported successfully.")

                    let percentage = Double(Double((indexValue))/Double(arrContactList.count))
                    let strPercentage = String(format: "%.0f", percentage * 100)

                    Logger.log("Import Contacts Percentage \(strPercentage) % and index: \(indexValue) Total Count: \(arrContactList.count)")

                    if indexValue == arrContactList.count - 1 {
                        Logger.log("Finished Import Contacts")
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - TableView DataSource
extension ContactBackupVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactBackupViewModel.arrBackupList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: ContactBackupTableViewCell.self, for: indexPath) as? ContactBackupTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(model: contactBackupViewModel.arrBackupList[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - TableView Delegate
extension ContactBackupVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlert(withTitle: "Restore Contacts", andMessage: "Are you sure you want to restore contacts from this file?", okAction: { [weak self] in
            guard let self = self else {
                return
            }
            self.restoreAndImportContacts(from: self.contactBackupViewModel.arrBackupList[indexPath.row].fileUrl)
        })
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete,
           FileManage.removeFileFromDocumentDirectory(fileUrl: contactBackupViewModel.arrBackupList[indexPath.row].fileUrl) {
            tblContactBackup.reloadData()
        }
    }
}
