//
//  PasswordTextField.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 9.07.2023.
//

import UIKit

class PasswordTextField: UITextField {
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Private Methods
    private func setup() {
        self.isSecureTextEntry = true
        
        let button = UIButton(frame: CGRect(x: -10, y: 0, width: 30, height: self.frame.height))
        button.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
        button.setImage(UIImage(systemName: "eye.fill"), for: .selected)
        button.tintColor = .gray
        
        let iconContainerView = UIView(frame: button.bounds)
        iconContainerView.addSubview(button)
        
        rightView = iconContainerView
        rightViewMode = .always
        button.addTarget(self, action: #selector(showHidePassword(_:)), for: .touchUpInside)
    }
    
    // MARK: - Button Action
    @objc private func showHidePassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !sender.isSelected
    }
    
}
