//
//  ZoomImageVC.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 30/11/23.
//

import UIKit

class ZoomImageVC: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var zoomImageView: ZoomImageView!

    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - SetupView
    func setupView() {
        zoomImageView.zoomMode = .fit
        zoomImageView.image = UIImage(named: "TestImage")
        zoomImageView.backgroundColor = .white
    }
}

// MARK: - ZoomScrollDelegate
extension ZoomImageVC: ZoomScrollDelegate {
    func scrollDidScroll(scrollView: UIScrollView) {
        print(scrollView.contentOffset)
    }
}
