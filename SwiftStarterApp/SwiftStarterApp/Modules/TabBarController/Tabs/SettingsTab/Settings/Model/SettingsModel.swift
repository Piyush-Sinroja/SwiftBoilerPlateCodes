//
//  SettingsModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/9/23.
//

import Foundation

struct SettingsModel {
    public var id: String { return UUID().uuidString }
    var title: String
}

enum SettingMenuItems: String {
    case UserList = "User List API"
    case UserListbyAlamofire = "User List by Alamofire API"
    case UserListUsingAsyncAwait = "User List Using Async Await"
    case FetchUserWithID = "Fetch User with ID"    
    case Contacts = "Contacts"
    case ChangedLanguage = "Changed Language"
    case Locations = "Locations"
    case ImageSelection = "Image Selection"
    case CustomAlert = "Custom Alert"
    case ZoomImage = "ZoomImage"
    case DatePicker = "DatePicker"
    case DropDown = "DropDown"
    case GraphQLApi = "GraphQLApi"
}
