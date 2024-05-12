//
//  ContactService.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 07/11/23.
//

import Foundation
import Contacts
import ContactsUI

// MARK: - ContactService Class
class ContactService: NSObject {

    // MARK: - Variables

    let appdelObj: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var contacts: [CNContact] = []
    var contactStore = CNContactStore()

    // MARK: - Check Contact Permission

    /// check contact permission
    /// - Parameter completion: true of false value of contact permission in completion handler
    func checkContactPermission(completion: @escaping(_ isGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
            case .authorized:
                completion(true)
            case .notDetermined:
                contactStore.requestAccess(for: .contacts) { granted, error in
                    Logger.log(error?.localizedDescription ?? "")
                    completion(granted)
                }
            case .denied,
                    .restricted:
                completion(false)
            @unknown default:
                break
        }
    }

    // MARK: - Fetch Contacts

    /// get all phone contacts
    /// - Parameter completion: completion handler with array of contact and contact permission
    func getAllContact(completion: @escaping(_ arrContacts: [CNContact], _ isGranted: Bool) -> Void) {
        checkContactPermission { [weak self] isGranted in
            if isGranted {
                self?.fetchContacts(completion: { (arrayContacts) in
                    completion(arrayContacts, isGranted)
                })
            } else {
                completion([], isGranted)
            }
        }
    }

    /// fetch contacts
    /// - Parameter completion: array of contact in completion handler
   private func fetchContacts(completion: @escaping(_ arrContact: [CNContact]) -> Void) {
        DispatchQueue.main.async {
            CustomLoader.shared.showIndicator()
        }
        DispatchQueue.global(qos: .userInitiated).async {
            var contacts: [CNContact] = []
            let fetchReq = CNContactFetchRequest.init(keysToFetch: [CNContactViewController.descriptorForRequiredKeys()])
            do {
                fetchReq.sortOrder = CNContactSortOrder.givenName
                try self.contactStore.enumerateContacts(with: fetchReq) { (contact, _) in
                    contacts.append(contact)
                }
            } catch let error as NSError {
                CustomLoader.shared.hideIndicator()
                Logger.log(error.localizedDescription)
            }
            DispatchQueue.main.async {
                CustomLoader.shared.hideIndicator()
                completion(contacts)
            }
        }
    }

    // MARK: - Export Contacts

    /// export contacts
    /// - Parameters:
    ///   - contacts: array of contact
    ///   - withPhotos: true if export with photos
    ///   - completion: exported contact file url and contact permission in completion handler
    func exportContacts(contacts: [CNContact], withPhotos: Bool = false, completion: @escaping(_ fileUrl: URL?, _ isGranted: Bool) -> Void) {
        checkContactPermission { isGranted in
            if isGranted {
                let createdDate = Date().getCurrentDate()
                let filename = "CB-\(String(describing: createdDate))"

                CustomLoader.shared.showIndicator()

                DispatchQueue.global(qos: .userInteractive).async {
                    do {
                        var data = Data()
                        if withPhotos {
                            try data = CNContactVCardSerialization.data(jpegPhotoContacts: contacts)
                        } else {
                            try data = CNContactVCardSerialization.data(with: contacts)
                        }

                        let toupleValues = FileManage.saveDataFileToDocumentDirectory(data: data, fileNameWithExtension: "\(filename).vcf")

                        DispatchQueue.main.async {
                            CustomLoader.shared.hideIndicator()
                            if let fileURL = toupleValues.fileUrl {
                                completion(fileURL, isGranted)
                            } else {
                                print(toupleValues.error?.localizedDescription ?? "")
                                completion(nil, isGranted)
                            }
                        }

                    } catch {
                        Logger.log(error.localizedDescription)
                        DispatchQueue.main.async {
                            CustomLoader.shared.hideIndicator()
                            completion(nil, isGranted)
                        }
                    }
                }
            } else {
                completion(nil, isGranted)
            }
        }
    }

    // MARK: - Import Contacts

    /// import contacts
    /// - Parameters:
    ///   - arrCont: array of contact
    ///   - view: view controller object
    func importContacts(arrContact: [CNContact], completionHandler: @escaping (_ indexValue: Int, _ isGranted: Bool) -> Void) {
        checkContactPermission {[weak self] isGranted in
            if isGranted {
                self?.addImportedContacts(arrContact: arrContact, completionHandler: completionHandler)
            } else {
                completionHandler(0, isGranted)
                //self?.openSetting(fromVc: view, isAddContact: true)
            }
        }
    }

    /// add Imported contacts
    /// - Parameters:
    ///   - arrContact: array of contact
    private func addImportedContacts(arrContact: [CNContact], completionHandler: @escaping (_ indexValue: Int, _ isGranted: Bool) -> Void) {
        DispatchQueue.global().async {
            for (index, cont) in arrContact.enumerated() {
                if let contact = cont.mutableCopy() as? CNMutableContact {
                    // create contact
                    let request = CNSaveRequest()

                    request.add(contact, toContainerWithIdentifier: nil)

                    do {
                        try self.contactStore.execute(request)
                        DispatchQueue.main.async {
                            completionHandler(index, true)
                        }
                    } catch let (error) {
                        Logger.log("contact import error:", error.localizedDescription)
                        DispatchQueue.main.async {
                            completionHandler(index, true)
                        }
                    }
                } else {
                    completionHandler(index, true)
                    break
                }
            }
        }
    }

    // MARK: - Delete Contacts

    /// delete contacts
    /// - Parameters:
    ///   - contact: An immutable object that stores information about a single contact, such as the contact's first name, phone numbers, and addresses.
    ///   - completionHandler: true if contact is deleted in completion handler
    func deleteContact(contact: CNContact, completionHandler: @escaping (_ isDeleted: Bool, _ isGranted: Bool) -> Void) {
        checkContactPermission {[weak self] isGranted in
            if isGranted {
                let isDeleted = self?.deleteContacts(contact: contact) ?? false
                completionHandler(isDeleted, isGranted)
            } else {
                completionHandler(false, isGranted)
            }
        }
    }

    /// delete contacts
    /// - Parameter contact: An immutable object that stores information about a single contact, such as the contact's first name, phone numbers, and addresses.
    /// - Returns: true if contact is deleted in completion handler
   private func deleteContacts(contact: CNContact) -> Bool {
        let saveRequest = CNSaveRequest()
        if let contactToUpdate = contact.mutableCopy() as? CNMutableContact {
            do {
                saveRequest.delete(contactToUpdate)
                try self.contactStore.execute(saveRequest)
                return true
            } catch let error {
                Logger.log("deleteContact error", error.localizedDescription)
                return false
            }
        }
        return false
    }

    // MARK: - Search Contacts -

    /// Search Contact from phone
    /// - parameter string: Search String.
    /// - parameter completionHandler: Returns Either [CNContact] or Error.
    public func searchContact(SearchString string: String, completionHandler: @escaping (_ result: Result<[CNContact], Error>) -> Void) {
        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        let predicate: NSPredicate = CNContact.predicateForContacts(matchingName: string)
        do {
            contacts = try contactStore.unifiedContacts(matching: predicate, keysToFetch: [CNContactVCardSerialization.descriptorForRequiredKeys()])
            completionHandler(.success(contacts))
        } catch {
            completionHandler(.failure(error))
        }
    }

    // MARK: - Restore contacts from vcf

    /// get all vcf file from document which we have exported to document directory
    func getAllVCFFilesFromDocumentDir() {
        if let allBackupFiles = FileManage.allFileListFromDocumentDir(whichExtension: "vcf") {
            var arrVcfFileUrl: [URL] = []
            allBackupFiles.forEach { (url) in
                let arrResult = url.lastPathComponent.components(separatedBy: "CB-")
                if arrResult.count > 1 {
                    let arrDateStr = arrResult[1].components(separatedBy: ".vcf")
                    if  arrDateStr.count > 1 {
                        arrVcfFileUrl.append(url)
                    }
                }
            }
        }
    }

    /// restore contacts from vCard
    /// - Parameters:
    ///   - fileUrl: vCard file url
    ///   - completion: array of contact in completion handler
    func restoreContacts(fromVCard fileUrl: URL, completion: @escaping(_ arrContactList: [CNContact]) -> Void) {
        DispatchQueue.global(qos: .default).async {
            do {
                let dataContact = try Data(contentsOf: fileUrl)
                let arrResult = try CNContactVCardSerialization.contacts(with: dataContact)
                DispatchQueue.main.async {
                    completion(arrResult)
                }
            } catch let error {
                Logger.log("error: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
}

// MARK: - CNContactVCardSerialization Extension

extension CNContactVCardSerialization {
    internal class func vcardDataAppendingPhoto(vcard data: Data, photoAsBase64String photoString: String) -> Data? {
        let vcardAsString = String(data: data, encoding: .utf8)
        //  let vcardPhoto = "PHOTO;TYPE=JPEG;ENCODING=BASE64:".appending(photoString)
        // let vcardPhotoThenEnd = vcardPhoto.appending("\nEND:VCARD")
        if let vcardPhotoAppended = vcardAsString?.replacingOccurrences(of: "END:VCARD", with: "PHOTO;ENCODING=b;TYPE=JPEG:\(photoString)\nEND:VCARD") {
            return vcardPhotoAppended.data(using: .utf8)
        }
        return nil
    }
    
    class func data(jpegPhotoContacts: [CNContact]) throws -> Data {
        var overallData = Data()
        for contact in jpegPhotoContacts {
            let data = try CNContactVCardSerialization.data(with: [contact])
            if contact.imageDataAvailable, let imgData = contact.imageData,
               let imgMain = UIImage(data: imgData),
               let resizeImg = imgMain.resizeImage(newWidth: 150),
               let base64imageString = resizeImg.jpegData(compressionQuality: 1)?.base64EncodedString(),
               let updatedData = vcardDataAppendingPhoto(vcard: data, photoAsBase64String: base64imageString) {
                overallData.append(updatedData)
            } else {
                overallData.append(data)
            }
        }
        return overallData
    }
}
