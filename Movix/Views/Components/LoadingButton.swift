//
//  LoadingButton.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import UIKit

class LoadingButton: UIButton {
    
    // MARK: - Properties
    var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Helper Methods
    
    /// Creates and configures the activity indicator.
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.white
        return activityIndicator
    }
    
    /// Shows and starts animating the activity indicator.
    private func showSpinning() {
        DispatchQueue.main.async {
            self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(self.activityIndicator)
            self.centerActivityIndicatorInButton()
            self.activityIndicator.startAnimating()
        }
    }
    
    /// Centers the activity indicator within the button.
    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        self.addConstraint(xCenterConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
    
    // MARK: - Public Methods
    
    /// Shows the loading state by hiding the button text and showing the activity indicator.
    func showLoading() {
        DispatchQueue.main.async {
            self.originalButtonText = self.titleLabel?.text
            self.setTitle("", for: .normal)
        }
        
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }
        
        showSpinning()
    }
    
    /// Hides the loading state by restoring the original button text and stopping the activity indicator.
    func hideLoading() {
        DispatchQueue.main.async {
            self.setTitle(self.originalButtonText, for: .normal)
            self.activityIndicator.stopAnimating()
        }
    }
    
    
}
