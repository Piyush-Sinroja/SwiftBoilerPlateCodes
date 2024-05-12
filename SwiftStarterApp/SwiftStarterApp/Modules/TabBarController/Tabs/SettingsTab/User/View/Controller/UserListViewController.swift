//
//  UserListViewController.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/1/23.
//

import UIKit

class UserListViewController: UIViewController {
    // MARK: - Variables

    private var viewModel: UserListViewModel = .init()

    var isUsingAlamofire = false
    var isUsingAsyncAwait = false
    var fetchWithUserID = false

    // MARK: - Outlets

    @IBOutlet var tableView: UITableView! {
        didSet {
            tableView.registerCell(type: CellUserList.self)
        }
    }
}

// MARK: - View Life Cycle

extension UserListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Uset Settings"
        self.observeEvent()
        self.fetchUserList()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func fetchUserList() {
        if isUsingAlamofire {
             viewModel.getUserList()
            //viewModel.asyncGetUserList()
            // viewModel.downLoadFile()
            // viewModel.getUserCarts()
            // viewModel.createTourist()
        } else if isUsingAsyncAwait {
            fetchUserListUsingAsync()
        } else if fetchWithUserID {
            fechUserWithID()
        } else {
            viewModel.fetchUserList()
        }
    }
}

// MARK: - API CALLS & BINDING

extension UserListViewController {
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
                    self.showAlert(withTitle: "Error", andMessage: "\(error?.description ?? "")")
                }
            }
        }

        viewModel.updateEventHandler = { [weak self] state in
            switch state {
            case .loading:
                self?.setLoading(true)
            case .success:
                DispatchQueue.main.async {
                    self?.setLoading(false)
                    self?.tableView.reloadData()
                }
            case .failedAF(let error):
                self?.setLoading(false)
                DispatchQueue.main.async {
                    self?.showAlert(withTitle: "Error", andMessage: "\(error?.localizedDescription ?? "")")
                }
            }
        }
    }
}

// MARK: - TableView DataSource & Delegate

extension UserListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(withType: CellUserList.self, for: indexPath) as? CellUserList else {
            return UITableViewCell()
        }
        let item = viewModel.users[indexPath.row]
        cell.configure(item)
        return cell
    }
}

// MARK: - Api Call Using Async Await

extension UserListViewController {
    func fetchUserListUsingAsync() {
        Task {
            do {
                self.setLoading(true)
                try await viewModel.fetchUserListUsingAsyncAwait()
                self.setLoading(false)
                self.tableView.reloadData()
            } catch {
                self.setLoading(false)
                self.showAlert(withTitle: "Error", andMessage: error.localizedDescription)
            }
        }
    }

    func fechUserWithID() {
        let params: [String: Any] = ["id": "1"]

        Task {
            do {
                self.setLoading(true)
                try await viewModel.fetchUserListUsingAsyncAwaitWithUserID(params: params)
                self.setLoading(false)
                self.tableView.reloadData()
            } catch {
                self.setLoading(false)                
                self.showAlert(withTitle: "Error", andMessage: error.localizedDescription)
            }
        }
    }
}
