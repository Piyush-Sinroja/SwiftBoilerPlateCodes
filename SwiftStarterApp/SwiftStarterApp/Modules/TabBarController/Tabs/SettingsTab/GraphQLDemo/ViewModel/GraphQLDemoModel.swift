//
//  GraphQLDemoModel.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 1/2/24.
//

import Foundation
import SpaceXAPI

class GraphQLDemoModel {
    var rockets: [RocketsQuery.Data.Rocket] = []
    var eventHandler: ((_ event: ViewState) -> Void)?

    func fetchRockets() {
        self.eventHandler?(.loading)

        let query = RocketsQuery()
        APIManagerGraphQL.shared.apollo.fetch(query: query) { [weak self] result in
            switch result {
            case .success(let value):
                self?.rockets = value.data?.rockets?.compactMap { $0 } ?? []
                self?.eventHandler?(.success)
            case .failure(let error):
                debugPrint(error.localizedDescription)
                self?.eventHandler?(.failed(.badRequest))

            }
        }
    }
}

extension GraphQLDemoModel {
    enum ViewState {
        case loading
        case success
        case failed(DataError?)
    }
}
