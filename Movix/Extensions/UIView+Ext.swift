//
//  UIView+Ext.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit

extension UIView {
    func addShadow(opacity: Float, shadowRadius: Float) {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.layer.shadowRadius = CGFloat(shadowRadius)
        self.layer.masksToBounds = false
    }
}
