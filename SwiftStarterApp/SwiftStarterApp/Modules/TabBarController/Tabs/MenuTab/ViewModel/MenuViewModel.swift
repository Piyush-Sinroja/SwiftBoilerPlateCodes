//
//  MenuViewModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/12/23.
//

import Foundation

class MenuViewModel {

  var arrMenuModel: [MenuModel] = []

  /// get menu details
  /// - Parameter completion: completion handler
  func getMenuDetails(completion: () -> Void) {
    let car = MenuSubDetails(name: "Car")
    let bike = MenuSubDetails(name: "Bike")
    let train = MenuSubDetails(name: "Train")
    let cycle = MenuSubDetails(name: "Cycle")
    let vehicles = MenuModel(isExpand: true, name: "Vehicles", menuSubDetails: [car, bike, train, cycle])

    let rose = MenuSubDetails(name: "Rose")
    let lotus = MenuSubDetails(name: "Lotus")
    let jasmine = MenuSubDetails(name: "Jasmine")
    let flowers = MenuModel(isExpand: true, name: "Flowers", menuSubDetails: [rose, lotus, jasmine])

    let potato = MenuSubDetails(name: "Potato")
    let tomato = MenuSubDetails(name: "Tomato")
    let brinjal = MenuSubDetails(name: "Brinjal")
    let veg = MenuModel(isExpand: true, name: "Vegetables", menuSubDetails: [potato, tomato, brinjal])

    let mouse = MenuSubDetails(name: "Mouse")
    let keyboard = MenuSubDetails(name: "Keyboard")
    let printer = MenuSubDetails(name: "Printer")
    let hardware = MenuModel(isExpand: true, name: "Hardware", menuSubDetails: [mouse, keyboard, printer])
    arrMenuModel = [vehicles, flowers, veg, hardware]
    completion()
  }
}
