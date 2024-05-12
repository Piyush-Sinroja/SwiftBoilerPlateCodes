//
//  ContactViewModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 22/11/23.
//

import Foundation
import Contacts
import ContactsUI

final class ContactViewModel {

    // MARK: - Variables
    var contactService = ContactService()
    var arrContactList = [ContactModel]()

    // MARK: - Get Contact

    /// get all contact
    /// - Parameter completion: completion with isGranted bool value
    func getAllContact(completion: @escaping(_ isGranted: Bool) -> Void) {
        contactService.getAllContact {[weak self] arrContacts, isGranted in
            guard isGranted else {
                completion(isGranted)
                return
            }
            self?.arrContactList = []
            arrContacts.forEach { (contact) in
                self?.arrContactList.append(ContactModel(contact: contact, isSelect: false))
            }
            completion(isGranted)
        }
    }

    // MARK: - Delete Contact

    /// delete contact
    /// - Parameters:
    ///   - index: index value
    ///   - completion: completion with isGranted bool value
    func deleteContact(for index: Int, completion: @escaping(_ isGranted: Bool) -> Void) {
        contactService.deleteContact(contact: arrContactList[index].contact) {[weak self] isDeleted, isGranted  in
            if isGranted,
               isDeleted {
                self?.arrContactList.remove(at: index)
            }
            completion(isGranted)
        }
    }

    // MARK: - Export Contact

    /// export contact
    /// - Parameters:
    ///   - contacts: array of contact
    ///   - completion: completion with fileUrl and isGranted bool value
    func exportContact(contacts: [CNContact], completion: @escaping(_ fileUrl: URL?, _ isGranted: Bool) -> Void) {
        contactService.exportContacts(contacts: contacts) { fileUrl, isGranted in
            guard isGranted,
                  let url = fileUrl else {
                completion(nil, isGranted)
                return
            }

            if let fileSize = url.fileSize(), let value = url.checkFileSize {
                Logger.log("export contacts url: \(url)")
                Logger.log("value: \(value)")
                Logger.log("fileSize: \(fileSize) contacts count: \(contacts.count) fileName: \(url.lastPathComponent)")
            }

            completion(url, isGranted)
        }
    }

    // MARK: - Restore and Import Contact

    /// restore contacts
    /// - Parameters:
    ///   - fileUrl: fileurl of contacts
    ///   - completion: completion with array of contact
    func restoreContacts(from fileUrl: URL, completion: @escaping(_ arrContactList: [CNContact]) -> Void) {
        contactService.restoreContacts(fromVCard: fileUrl, completion: completion)
    }

    /// import contacts from vcf file
    /// - Parameters:
    ///   - contacts: array of contacts
    ///   - completionHandler: completion with indexValue and isGranted bool value
    func importContacts(contacts: [CNContact], completionHandler: @escaping (_ indexValue: Int, _ isGranted: Bool) -> Void) {
        contactService.importContacts(arrContact: contacts, completionHandler: completionHandler)
    }
}
