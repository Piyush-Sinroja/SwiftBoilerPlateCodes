//
//  ProfileViewModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 12/5/23.
//

import Foundation

class ProfileViewModel {
    
    // MARK: - DATA MANAGER
    private let manager = UserManager()

    // MARK: - Fetch User Profile
    func fetchUserProfile() -> User? {
        let uuid = UUID(uuidString: StorageService.shared.userID ?? "")
        let user = manager.fetchUser(byIdentifier: uuid ?? UUID())
        return user
    }
     
    // MARK: - Update User Profile
    func updateUser(user: User) {
        _ = manager.updateUser(user: user)
    }
}
