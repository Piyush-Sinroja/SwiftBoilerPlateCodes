//
//  SettingsViewModel.swift
//  SwiftStarterApp
//
//  Created by Pratik Panchal on 11/9/23.
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
        item.append(SettingsModel(title: "User List"))
        item.append(SettingsModel(title: "User List by Alamofire"))
        item.append(SettingsModel(title: "Contacts"))
        item.append(SettingsModel(title: "Changed Language"))
        item.append(SettingsModel(title: "Locations"))
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
