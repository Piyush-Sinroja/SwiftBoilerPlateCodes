//
//  DropDownVC.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 05/12/23.
//

import UIKit
import DropDown

class DropDownVC: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var vehicleTextField: UITextField!
    @IBOutlet weak var vehicleButton: UIButton!

    @IBOutlet weak var productTextField: UITextField!
    @IBOutlet weak var productButton: UIButton!

    // MARK: - Variables

    var dropDownVehicles = DropDown()
    var dropDownProduct = DropDown()

    // MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Setup View

    /// setup view
    func setupView() {
        DropDown.appearance().textColor = UIColor.black
        DropDown.appearance().selectedTextColor = UIColor.red
        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 15)
        DropDown.appearance().backgroundColor = UIColor.white
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray
        DropDown.appearance().setupCornerRadius(10)
        //DropDown.appearance().cellHeight = 60

        setDropDown(dropDown: dropDownVehicles, button: vehicleButton, dropDownArray: ["Car", "Motorcycle", "Truck"], textField: vehicleTextField)
        setDropDown(dropDown: dropDownProduct, button: productButton, dropDownArray: ["Computer", "Mobile", "Cable"], textField: productTextField)
    }

    /// set drop down
    /// - Parameters:
    ///   - dropDown: DropDown Object
    ///   - button: sender button
    ///   - dropDownArray: array of string which will in dropdown list
    ///   - textField: textfield which will be used to show selected value
    func setDropDown(dropDown: DropDown, button: UIButton, dropDownArray: [String], textField: UITextField) {
        dropDown.anchorView = button
        dropDown.bottomOffset = CGPoint(x: 0, y: button.bounds.height)
        //dropDown.width = 200
        dropDown.dataSource = dropDownArray

        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            textField.text = item
            print("Selected item: \(item) at index: \(index)")
        }

        // cancel action triggered
//        dropDown.cancelAction = { [unowned self] in
//            print("Drop down dismissed")
//        }

//        dropDown.willShowAction = { [unowned self] in
//            print("Drop down will show")
//        }
    }

    // MARK: - IBActions
    @IBAction func vehicleButtonAction(_ sender: Any) {
        dropDownClick(dropDown: dropDownVehicles)
    }

    @IBAction func productButtonAction(_ sender: Any) {
        dropDownClick(dropDown: dropDownProduct)
    }

    /// drop down click
    /// - Parameter dropDown: DropDown object
    func dropDownClick(dropDown: DropDown) {
        print("selectedItem", dropDown.selectedItem ?? "No Item Selected")
        print("SelectedRow", dropDown.indexForSelectedRow ?? "No Index Selected")
        dropDown.show()
    }
}
