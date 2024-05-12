//
//  UserListViewModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/1/23.
//

import Alamofire
import Foundation

final class UserListViewModel {
    // MARK: - Variables

    var users: [UserDetails] = []

    // MARK: - Closures

    var eventHandler: ((_ event: ViewState) -> Void)?
    var updateEventHandler: ((_ event: ViewUpdateState) -> Void)?
}

// MARK: - Api Call Normal flow

extension UserListViewModel {
    func fetchUserList() {
        self.eventHandler?(.loading)
        APIManager.shared.request(modelType: [UserDetails].self, type: APIEndPoint.users) { response in
            switch response {
            case .success(let users):
                self.users = users
                self.eventHandler?(.success)
            case .failure(let error):
                self.eventHandler?(.failed(error))
            }
        }
    }
}

// MARK: - Api Call Using Async Await

extension UserListViewModel {
    @MainActor
    func fetchUserListUsingAsyncAwait() async throws {
        let users: [UserDetails] = try await APIManagerAsync.shared.request(type: APIEndPointAsync.users)
        self.users = users
    }
        
    func fetchUserListUsingAsyncAwaitWithUserID(params: [String: Any]) async throws {
        let users: [UserDetails] = try await APIManagerAsync.shared.request(type: APIEndPointAsync.usersWithID(params: params))
        self.users = users
    }
}

// MARK: - Api Call Using Alamofire

extension UserListViewModel {
    func getUserList() {
        AlamofireApiService.shared().requestFor(modelType: [UserDetails].self, apiType: ApiTypeConfiguration.users) { [weak self] response in
            switch response {
                case .success(let users):
                    self?.users = users
                    self?.updateEventHandler?(.success)
                case .failure(let error):
                    self?.updateEventHandler?(.failedAF(error))
            }
        }
    }

    // MARK: - Async Await Get API

    /// get user list from async await
    func asyncGetUserList() {
        self.updateEventHandler?(.loading)
        Task {
            do {
                let userList = try await AlamofireApiService.shared().asyncRequestFor(modelType: [UserDetails].self, apiType: ApiTypeConfiguration.users)
                self.users = userList
                self.updateEventHandler?(.success)
            } catch {
                print("Errorrr-r---- \(error.localizedDescription)")
                self.updateEventHandler?(.failedAF(error))
            }
        }
    }

    // MARK: - Get API With Query Parameters

    /// get api with query parameters
    func getUserCarts() {
        let param = ["userId": 1]
        AlamofireApiService.shared().requestFor(modelType: [UserCart].self, apiType: ApiTypeConfiguration.getUserCart, param: param) { [weak self] response in
            switch response {
                case .success(let userCarts):
                    self?.updateEventHandler?(.success)
                    Logger.log("userCarts: \(userCarts)")
                case .failure(let error):
                    self?.updateEventHandler?(.failedAF(error))
            }
        }
    }

    // MARK: - Download File

    /// download file from server
    func downLoadFile() {
        AlamofireApiService.shared().downloadRequest(fileName: "MyFileName.zip", apiType: ApiTypeConfiguration.downloadFile, param: nil) { double in
            Logger.log("DownloadProgress: \(double)")
        } completionHandler: { [weak self] filePath, error in
            self?.updateEventHandler?(.success)
            guard error == nil else {
                self?.updateEventHandler?(.failedAF(error))
                return
            }
            guard let filePath else {
                return
            }
            Logger.log("filePath \(filePath)")
        }
    }

    // MARK: - Post With Body Parameters

    // post api with body parameters
    func createTourist() {
        let param = ["tourist_name": "Vivek",
                     "tourist_email": "\(CommonFunctions.randomString(length: 8))@gmail.com",
                     "tourist_location": "London"]

        AlamofireApiService.shared().requestFor(modelType: TouristModel.self, apiType: ApiTypeConfiguration.createTourist, param: param) { [weak self] response in
            switch response {
                case .success(let tourist):
                    self?.updateEventHandler?(.success)
                    Logger.log("tourist Details: \(tourist)")
                case .failure(let error):
                    self?.updateEventHandler?(.failedAF(error))
            }
        }
    }
}

extension UserListViewModel {
    enum ViewState {
        case loading
        case success
        case failed(DataError?)
    }

    enum ViewUpdateState {
        case loading
        case success
        case failedAF(Error?)
    }
}
