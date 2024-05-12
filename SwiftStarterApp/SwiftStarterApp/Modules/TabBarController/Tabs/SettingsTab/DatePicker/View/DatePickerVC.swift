//
//  DatePickerVC.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 05/12/23.
//

import UIKit

@objc protocol DatePickerDelegate: NSObjectProtocol {
    func datePickerDidSelectDate(_ date: Date, mode: UIDatePicker.Mode)
}

class DatePickerVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var constraintDatePickerViewBottom: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var viewMain: UIView!

    // MARK: - Variables
    var maximumDate: Date?
    var minimumDate: Date?
    var selectedDate = Date()
    var localeIdentifier: String = "en_US"
    var selectButtonTitle = Constant.Button.okButton
    var cancelButtonTitle = Constant.Button.cancelButton
    var datePickerType: UIDatePicker.Mode = .date
    private let openCloseAnimationTime = 0.2
    //Delegate
    weak var delegate: DatePickerDelegate?

    enum DatePickerViewPosition: CGFloat {
        case up = 0
        case down = -300
    }

    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        openAnimation()
    }

    // MARK: - Setup

    /// setup date picker
    func setupDatePicker() {
        datePicker.date = self.selectedDate
        if self.minimumDate != nil {
            datePicker.minimumDate = minimumDate
            datePicker.maximumDate = Date().addingTimeInterval(365.0 * 24.0 * 60.0 * 60.0)
            if self.minimumDate! > self.selectedDate {
                datePicker.date = self.minimumDate!
            }
        }

        if self.maximumDate != nil {
            datePicker.maximumDate = Date()
        }
        datePicker.locale = Locale(identifier: localeIdentifier)
        datePicker.autoresizingMask = [.flexibleWidth]
        datePicker.clipsToBounds = true
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        let tap = UITapGestureRecognizer(target: self, action: #selector(DatePickerVC.closerVc))
        viewMain.addGestureRecognizer(tap)
    }

    // MARK: - IBActions
    @IBAction func btnDoneAction(_ sender: Any) {
        self.delegate?.datePickerDidSelectDate(self.datePicker.date, mode: datePickerType)
        closerVc()
    }

    @IBAction func btnCancelAction(_ sender: Any) {
        closerVc()
    }

    // MARK: - Helper Methods

    /// open animation
    private func openAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.viewMain.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
            self.viewOpenCloseAnimation(position: DatePickerViewPosition.up)
        })
    }

    /// close view controller
    @objc func closerVc() {
        viewOpenCloseAnimation(position: .down)
    }

    /// view open close animation
    /// - Parameter position: date pickerview position
    private func viewOpenCloseAnimation(position: DatePickerViewPosition) {
        if position == .up {
            viewAnimation(duration: openCloseAnimationTime, postion: position, completion: nil)
        } else {
            viewAnimation(duration: openCloseAnimationTime, postion: position) {
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewMain.backgroundColor = UIColor.clear
                }, completion: { (_) in
                    self.dismiss(animated: false, completion: nil)
                })
            }
        }
    }

    /// view animation
    /// - Parameters:
    ///   - duration: animation duration
    ///   - postion: date pickerview position
    ///   - completion: completion handler
    private func viewAnimation(duration: TimeInterval, postion: DatePickerViewPosition, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            self.constraintDatePickerViewBottom.constant = postion.rawValue
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            completion?()
        })
    }
}
