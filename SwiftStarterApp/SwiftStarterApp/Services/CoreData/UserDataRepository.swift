//
//  UserDataRepository.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/28/23.
//

import Foundation
import CoreData

protocol UserRepository {
    func create(user: User)
    func getAll() async -> [User]
    func get(byIdentifier id: UUID) -> User?
    func update(user: User) -> Bool
    func delete(id: UUID) -> Bool
}

struct UserDataRepository: UserRepository {
    func create(user: User) {
        let cdUserEntity = CDUserEntity(context: PersistentStorage.shared.context)
        cdUserEntity.id = user.id
        cdUserEntity.username = user.username
        cdUserEntity.email = user.email
        cdUserEntity.dob = user.dob
        cdUserEntity.profilePic = user.profilePic
        cdUserEntity.password = user.password
        StorageService.shared.userID = user.id.uuidString
        PersistentStorage.shared.saveContext()
    }

    func getAll() async -> [User] {
        let result = PersistentStorage.shared.fetchManagedObject(managedObject: CDUserEntity.self)

        var users: [User] = []

        result?.forEach { cdUserEntity in
            users.append(cdUserEntity.convertToUserEntity())
        }

        return users
    }

    func get(byIdentifier id: UUID) -> User? {
        let result = getCDUser(byIdentifier: id)
        guard result != nil else { return nil }
        return result?.convertToUserEntity()
    }

    func update(user: User) -> Bool {
        let cDUserEntity = getCDUser(byIdentifier: user.id)
        guard cDUserEntity != nil else { return false }

        cDUserEntity?.email = user.email
        cDUserEntity?.username = user.username
        cDUserEntity?.profilePic = user.profilePic

        PersistentStorage.shared.saveContext()
        return true
    }

    func delete(id: UUID) -> Bool {
        let cDUserEntity = getCDUser(byIdentifier: id)
        guard cDUserEntity != nil else { return false }

        PersistentStorage.shared.context.delete(cDUserEntity!)
        PersistentStorage.shared.saveContext()
        return true
    }

    private func getCDUser(byIdentifier id: UUID) -> CDUserEntity? {
        let fetchRequest = NSFetchRequest<CDUserEntity>(entityName: "CDUserEntity")
        let predicate = NSPredicate(format: "id==%@", id as CVarArg)

        fetchRequest.predicate = predicate
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first

            guard result != nil else { return nil }

            return result

        } catch {
            debugPrint(error)
        }

        return nil
    }
}
