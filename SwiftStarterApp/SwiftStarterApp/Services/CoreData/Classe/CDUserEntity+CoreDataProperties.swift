//
//  CDUserEntity+CoreDataProperties.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/27/23.
//
//

import CoreData
import Foundation

public extension CDUserEntity {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CDUserEntity> {
        return NSFetchRequest<CDUserEntity>(entityName: "CDUserEntity")
    }
    
    @NSManaged var id: UUID?
    @NSManaged var username: String?
    @NSManaged var email: String?
    @NSManaged var dob: String?
    @NSManaged var password: String?
    @NSManaged var profilePic: Data?
}

extension CDUserEntity: Identifiable {
    static var identifier: String {
        return UUID().uuidString
    }
    
    func convertToUserEntity() -> User {
        return User(id: self.id!, username: self.username ?? "", email: self.email ?? "", dob: self.dob ?? "", password: self.password ?? "", profilePic: self.profilePic!)
    }
}
