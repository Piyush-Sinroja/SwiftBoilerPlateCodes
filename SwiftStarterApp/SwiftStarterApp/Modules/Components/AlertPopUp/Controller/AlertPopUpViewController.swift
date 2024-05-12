//
//  AlertPopUpViewController.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/27/23.
//

import UIKit

class AlertPopUpViewController: UIViewController {
    // MARK: - Properties

    var okayButtonTapped: (() -> Void)?
    var cancelButtonTapped: (() -> Void)?
    var closeButtonTapped: (() -> Void)?

    var titleMessage = ""
    var descriptionMessage = ""
    var imageName = ""

    // MARK: - Outlets

    @IBOutlet private var backgroundView: UIView!
    @IBOutlet private var contentView: UIView! {
        didSet {
            contentView.layer.cornerRadius = 10
        }
    }

    @IBOutlet private var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.openSans(of: 22, in: .regular)
            titleLabel.textColor = .hex_000000_Black
            titleLabel.textAlignment = .center
        }
    }

    @IBOutlet private var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = UIFont.openSans(of: 16, in: .regular)
            descriptionLabel.textColor = .hex_000000_Black
            descriptionLabel.textAlignment = .center
        }
    }

    @IBOutlet private var saveButton: ReusableButton! {
        didSet {
            saveButton.viewModel = ReusableButtonViewModel(
                title: LocalizedKey.Okay.localized(),
                titleColor: .hex_000000_Black,
                borderColor: .hex_000000_Black,
                borderWidth: 1,
                cornerRadius: 3,
                font: UIFont.openSans(of: 14, in: .regular)
            )
            saveButton.tapped = { [weak self] in
                self?.okayButtonTapped?()
                self?.hide()
            }
        }
    }

    @IBOutlet private var cancelButton: ReusableButton! {
        didSet {
            cancelButton.viewModel = ReusableButtonViewModel(
                title: LocalizedKey.Cancel.localized(),
                titleColor: .hex_808080_White,
                backgroundColor: .hex_000000_Black,
                cornerRadius: 3,
                font: UIFont.openSans(of: 14, in: .regular)
            )
            cancelButton.tapped = { [weak self] in
                self?.cancelButtonTapped?()
                self?.hide()
            }
        }
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        closeButtonTapped?()
        hide()
    }
    
    @IBOutlet var alertImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black.withAlphaComponent(0.8)

        titleLabel.text = titleMessage
        descriptionLabel.text = descriptionMessage

        alertImageView.isHidden = imageName.isEmpty
        alertImageView.image = UIImage(systemName: imageName)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with _: UIEvent?) {
        if touches.first?.view?.tag == 10 {
            hide()
        }
    }

    private func hide() {
        dismiss(animated: true)
    }
}
