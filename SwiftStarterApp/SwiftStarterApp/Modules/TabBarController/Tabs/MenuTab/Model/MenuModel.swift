//
//  MenuModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/12/23.
//

import Foundation

struct MenuModel {
  var isExpand: Bool
  var name: String
  var arrMenuSubDetails: [MenuSubDetails]
  init(isExpand: Bool, name: String, menuSubDetails: [MenuSubDetails]) {
    self.isExpand = isExpand
    self.name = name
    self.arrMenuSubDetails = menuSubDetails
  }
}

struct MenuSubDetails {
  var name: String
}
