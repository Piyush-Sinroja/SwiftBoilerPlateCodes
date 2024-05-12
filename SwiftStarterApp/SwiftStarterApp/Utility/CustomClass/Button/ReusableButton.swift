//
//  ReusableButton.swift
//  SwiftStarterApp
//
//  Created by Piyush Sinroja on 11/9/23.
//

import UIKit

// MARK: - ReusableButtonViewModel

struct ReusableButtonViewModel {
    let title: String
    let titleColor: UIColor
    var backgroundColor: UIColor?
    var borderColor: UIColor = .clear
    var borderWidth: CGFloat = 0
    var cornerRadius: CGFloat = 0
    var font: UIFont?
    var contentEdgeInsets: UIEdgeInsets?
    var textAlignment: UIControl.ContentHorizontalAlignment?
    var underlined: Bool = false
}

// MARK: - ReusableButton

class ReusableButton: UIView {
    // MARK: - Outlets

    @IBOutlet private var button: UIButton! {
        didSet {
            button.titleLabel?.font = .openSans(of: 16, in: .regular)
        }
    }

    // MARK: - ViewModel
    
    var viewModel: ReusableButtonViewModel! {
        didSet {
            propertyChanged()
        }
    }
    
    var isEnabled: Bool {
        get {
            button.isEnabled
        }
        set {
            button.isEnabled = newValue
            updateEnabled(newValue)
        }
    }
    
    // MARK: - Properties
    
    var tapped: (() -> Void)?
    
    private var underlineAttributes: NSAttributedString? {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: viewModel.font ?? .systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: viewModel.titleColor,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSAttributedString(string: viewModel.title, attributes: attributes)
        
        return attributedString
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let view = loadFromNib()

        view.frame = bounds
        addSubview(view)
        backgroundColor = .clear
    }

    // MARK: - Methods
    
    private func propertyChanged() {
        if viewModel.underlined {
            button.setAttributedTitle(underlineAttributes, for: .normal)
        } else {
            button.setTitle(viewModel.title, for: .normal)
            button.setTitleColor(viewModel.titleColor, for: .normal)
            button.backgroundColor = viewModel.backgroundColor
            button.titleLabel?.font = viewModel.font
        }
        
        button.layer.borderWidth = viewModel.borderWidth
        button.layer.borderColor = viewModel.borderColor.cgColor
        button.layer.cornerRadius = viewModel.cornerRadius
        
        if let textAlignment = viewModel.textAlignment {
            button.contentHorizontalAlignment = textAlignment
        }
    }
    
    private func updateEnabled(_ enabled: Bool) {
        if enabled {
            button.backgroundColor = viewModel.backgroundColor
            button.layer.borderWidth = viewModel.borderWidth
            button.layer.borderColor = viewModel.borderColor.cgColor
            button.setTitleColor(viewModel.titleColor, for: .normal)
        } else {
            button.backgroundColor = .gray
            button.layer.borderWidth = 0
            button.setTitleColor(.white, for: .normal)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func didTapButton(_ sender: Any) {
        tapped?()
    }
}
