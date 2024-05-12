//
//  ImagePickerViewController.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/23/23.
//

import UIKit

class ImagePickerViewController: UIViewController {
    // MARK: - Outlets

    @IBOutlet var selectedImage: UIImageView!
    var imagePicker: ImagePicker!

    @IBOutlet var photoGalleryButton: ReusableButton! {
        didSet {
            photoGalleryButton.viewModel = ReusableButtonViewModel(
                title: "Select Photo",
                titleColor: .hex_808080_White,
                backgroundColor: .hex_000000_Black,
                cornerRadius: 8,
                font: .openSans(of: 16, in: .semiBold)
            )
            photoGalleryButton.tapped = { [weak self] in
                guard let self = self else { return }
                self.imagePicker.present(from: self.view)
            }
        }
    }
}

// MARK: View Life Cycle

extension ImagePickerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Image Selection"

        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
}

// MARK: ImagePicker Delegate
extension ImagePickerViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.selectedImage.image = image
    }
}
