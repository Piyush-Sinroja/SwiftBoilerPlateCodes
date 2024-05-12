//
//  UserModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/27/23.
//

import Foundation

struct User {
    let id: UUID
    var username: String
    var email: String
    var dob: String
    var password: String
    var profilePic: Data?
}
