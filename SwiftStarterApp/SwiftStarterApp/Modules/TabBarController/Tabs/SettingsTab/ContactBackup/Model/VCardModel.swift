//
//  VCardModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 23/11/23.
//

import Foundation

class VCardModel {

    var isSelected: Bool
    var fileUrl: URL
    var createdDate: Date

    init(isSelected: Bool, fileUrl: URL, createdDate: Date) {
        self.isSelected = isSelected
        self.fileUrl = fileUrl
        self.createdDate = createdDate
    }
}
