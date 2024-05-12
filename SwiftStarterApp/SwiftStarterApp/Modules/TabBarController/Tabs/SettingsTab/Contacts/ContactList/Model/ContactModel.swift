//
//  ContactModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 22/11/23.
//

import Foundation
import Contacts
import ContactsUI

class ContactModel: Equatable {

    // MARK: - Variables
    
    var isSelect: Bool
    var contact: CNContact

    init(contact: CNContact, isSelect: Bool) {
        self.contact = contact
        self.isSelect = isSelect
    }

    static func == (lhs: ContactModel, rhs: ContactModel) -> Bool {
        return true
    }
}
