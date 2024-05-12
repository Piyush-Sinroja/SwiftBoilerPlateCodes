//
//  UserManager.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/28/23.
//

import Foundation

struct UserManager {
    private let userDataRepository = UserDataRepository()

    func createUser(user: User) {
        userDataRepository.create(user: user)
    }

    func fetchUser() async -> [User] {
        return await userDataRepository.getAll()
    }

    func fetchUser(byIdentifier id: UUID) -> User? {
        return userDataRepository.get(byIdentifier: id)
    }

    func updateUser(user: User) -> Bool {
        return userDataRepository.update(user: user)
    }

    func deleteUser(id: UUID) -> Bool {
        return userDataRepository.delete(id: id)
    }
}
