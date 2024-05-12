//
//  GraphQLDemoViewController.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 1/2/24.
//

//GraphQL studio: https://studio.apollographql.com/public/SpaceX-pxxbxen/variant/current/explorer

import UIKit

class GraphQLDemoViewController: UIViewController {

    let viewModel: GraphQLDemoModel = .init()
    
    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.registerCell(type: CellRockets.self)
        }
    }      
}

// MARK: - View Life Cycle
extension GraphQLDemoViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "GraphQL API"
        self.observeEvent()

        viewModel.fetchRockets()
    }
}

// MARK: - API CALLS & BINDING

extension GraphQLDemoViewController {
    func observeEvent() {
        viewModel.eventHandler = { state in
            switch state {
            case .loading:
                self.setLoading(true)
            case .success:
                DispatchQueue.main.async {
                    self.setLoading(false)
                    self.tableView.reloadData()
                }
            case .failed(let error):
                self.setLoading(false)
                DispatchQueue.main.async {
                    self.showAlert(withTitle: "Error", andMessage: "\(error?.errorDescription ?? "")")
                }
            }
        }
    }
}

// MARK: - TableView DataSource & Delegate

extension GraphQLDemoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rockets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: CellRockets.self, for: indexPath) as? CellRockets else {
            return UITableViewCell()
        }
        
        let item = viewModel.rockets[indexPath.row]
        cell.configure(item)
        return cell
    }
}
