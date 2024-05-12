//
//  ContactBackupViewModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 23/11/23.
//

import Foundation
import Contacts
import ContactsUI

final class ContactBackupViewModel {
    var arrBackupList: [VCardModel] = []
    var contactService = ContactService()
    
    func restoreContacts(from fileUrl: URL, completion: @escaping(_ arrContactList: [CNContact]) -> Void) {
        contactService.restoreContacts(fromVCard: fileUrl, completion: completion)
    }

    func importContacts(contacts: [CNContact], completionHandler: @escaping (_ indexValue: Int, _ isGranted: Bool) -> Void) {
        contactService.importContacts(arrContact: contacts, completionHandler: completionHandler)
    }

    func getAllContactBackupFilesFromDocumentDir(completionHandler: @escaping () -> Void) {
        if let allBackupFiles = FileManage.allFileListFromDocumentDir(whichExtension: "vcf") {
            arrBackupList = []
            allBackupFiles.forEach { (url) in
                let arrResult = url.lastPathComponent.components(separatedBy: "CB-")
                if arrResult.count > 1 {
                    let arrDateStr = arrResult[1].components(separatedBy: ".vcf")
                    if  arrDateStr.count > 1, let createdDate = arrDateStr[0].getDateFromString(formate: "yyyy-MM-dd-HHmmss") {
                        arrBackupList.append(VCardModel(isSelected: false, fileUrl: url, createdDate: createdDate))
                    }
                }
            }
        }
        arrBackupList.sort { $0.createdDate > $1.createdDate }
        completionHandler()
    }
}
