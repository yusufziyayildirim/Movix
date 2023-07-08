//
//  UITextField+Ext.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit

extension UITextField {
    func addLeftIcon(_ icon: UIImage?) {
        let iconImageView = UIImageView(image: icon)
        iconImageView.contentMode = .center
        iconImageView.frame = CGRect(x: 10, y: 0, width: 20, height: self.frame.height)
        iconImageView.tintColor = .gray
        
        let iconContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: self.frame.height))
        iconContainerView.addSubview(iconImageView)
        
        self.leftView = iconContainerView
        self.leftViewMode = .always
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
}
