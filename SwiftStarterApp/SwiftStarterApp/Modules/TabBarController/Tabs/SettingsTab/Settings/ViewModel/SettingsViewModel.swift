//
//  SettingsViewModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/9/23.
//

import Foundation

final class SettingsViewModel {
    var items: [SettingsModel] = []
    var eventHandler: ((_ event: ViewState) -> Void)?

    func fetchMenuItemsList() {
        self.eventHandler?(.loading)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            self.items = self.mockItemList()
            self.eventHandler?(.success)
        }
    }

    func mockItemList() -> [SettingsModel] {
        var item = [SettingsModel]()
        item.append(SettingsModel(title: "User List API"))
        item.append(SettingsModel(title: "User List by Alamofire API"))
        item.append(SettingsModel(title: "User List Using Async Await"))
        item.append(SettingsModel(title: "Fetch User with ID"))
        item.append(SettingsModel(title: "Contacts"))
        item.append(SettingsModel(title: "Changed Language"))
        item.append(SettingsModel(title: "Locations"))
        item.append(SettingsModel(title: "Image Selection"))
        item.append(SettingsModel(title: "Custom Alert"))
        item.append(SettingsModel(title: "ZoomImage"))
        item.append(SettingsModel(title: "DatePicker"))
        item.append(SettingsModel(title: "DropDown"))
        item.append(SettingsModel(title: "GraphQLApi"))
        
        return item
    }
}

extension SettingsViewModel {
    enum ViewState {
        case loading
        case success
        case failed(DataError?)
    }
}
