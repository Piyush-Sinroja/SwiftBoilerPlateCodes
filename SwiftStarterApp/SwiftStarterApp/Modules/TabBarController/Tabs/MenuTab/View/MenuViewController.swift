//
//  MenuViewController.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/7/23.
//

import UIKit

class MenuViewController: UIViewController {

  // MARK: - IBOutlets

  @IBOutlet weak var tableview: UITableView! {
    didSet {
      tableview.registerCell(type: ExpandTableViewCell.self)
    }
  }

  // MARK: - Variables
  var menuViewModel: MenuViewModel = .init()

  // MARK: - View Controller Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    tableview.estimatedRowHeight = 44.0
    tableview.rowHeight = UITableView.automaticDimension
    self.navigationItem.title = "Menu"
    removeSpaceBetweenTwoHeader()
    menuViewModel.getMenuDetails {
      tableview.reloadData()
    }
  }

  func removeSpaceBetweenTwoHeader() {
    if #available(iOS 15.0, *) {
      tableview.sectionHeaderTopPadding = 0
    }
  }

  // MARK: - Tap Gesture Handle

  @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
    guard let expandHeaderView = sender?.view as? ExpandHeaderView else {
      return
    }
    expandOrCloseTableCell(expandHeaderView: expandHeaderView)
  }

  /// expand or close table view cell
  /// - Parameter expandHeaderView: ExpandHeaderView
  func expandOrCloseTableCell(expandHeaderView: ExpandHeaderView) {
    var arrIndexPath: [IndexPath] = []
    let rows = menuViewModel.arrMenuModel[expandHeaderView.tag].arrMenuSubDetails.count
    for value in 0...rows-1 {
      arrIndexPath.append(IndexPath(row: value, section: expandHeaderView.tag))
    }
    if menuViewModel.arrMenuModel[expandHeaderView.tag].isExpand {
      menuViewModel.arrMenuModel[expandHeaderView.tag].isExpand = false
      self.tableview.deleteRows(at: arrIndexPath, with: .fade)
    } else {
      menuViewModel.arrMenuModel[expandHeaderView.tag].isExpand = true
      self.tableview.insertRows(at: arrIndexPath, with: .fade)
    }
    expandHeaderView.animateImage(isExpanded: menuViewModel.arrMenuModel[expandHeaderView.tag].isExpand)

    //when using reload section then getting animation issue
    // self.tableview.reloadSections([expandHeaderView.tag], with: .none)

    //animation to reload sections
    //      let currentOffset = self.tableview.contentOffset
    //      UIView.setAnimationsEnabled(false)
    //      self.tableview.beginUpdates()
    //      self.tableview.reloadSections([expandHeaderView.tag], with: .bottom)
    //      tableview.endUpdates()
    //      UIView.setAnimationsEnabled(true)
    //      self.tableview.setContentOffset(currentOffset, animated: false)
  }

  /// call this function if need to open one cell and close other cell
  /// - Parameter tag: ExpandHeaderView tag
  func openOneAndCloseOthers(tag: Int) {
    for index in menuViewModel.arrMenuModel.indices {
      if index == tag {
        if menuViewModel.arrMenuModel[index].isExpand {
          menuViewModel.arrMenuModel[index].isExpand = false
        } else {
          menuViewModel.arrMenuModel[index].isExpand = true
        }
      } else {
        menuViewModel.arrMenuModel[index].isExpand = false
      }
    }
    self.tableview.reloadData()
  }
}

// MARK: - UITableViewDataSource Methods
extension MenuViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return menuViewModel.arrMenuModel.count
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuViewModel.arrMenuModel[section].isExpand ? menuViewModel.arrMenuModel[section].arrMenuSubDetails.count : 0
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueCell(withType: ExpandTableViewCell.self, for: indexPath) as? ExpandTableViewCell else {
      return UITableViewCell()
    }
    cell.configureCell(subDetails: menuViewModel.arrMenuModel[indexPath.section].arrMenuSubDetails[indexPath.row])
    return cell
  }
}

// MARK: - UITableViewDelegate Methods
extension MenuViewController: UITableViewDelegate, UIGestureRecognizerDelegate {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let expandHeaderView: ExpandHeaderView = ExpandHeaderView.fromNib()
    expandHeaderView.tag = section
    expandHeaderView.categoryNameLabel.text =  menuViewModel.arrMenuModel[section].name
    expandHeaderView.animateImage(isExpanded: menuViewModel.arrMenuModel[expandHeaderView.tag].isExpand)
    expandHeaderView.isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.handleTap(_:)))
    tap.numberOfTapsRequired = 1
    tap.delegate = self
    expandHeaderView.addGestureRecognizer(tap)
    return expandHeaderView
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 40.0
  }
}
