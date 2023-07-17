//
//  ChangePasswordVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 16.07.2023.
//

import UIKit

protocol ChangePasswordViewModelDelegate: AnyObject{
    func message(message: String, isSuccess: Bool)
    func updateIndicator(isLoading: Bool)
}

class ChangePasswordVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var oldPasswordTextField: PasswordTextField!
    @IBOutlet weak var newPasswordTextField: PasswordTextField!
    @IBOutlet weak var newPasswordConfrimTextField: PasswordTextField!
    @IBOutlet weak var changePasswordButton: LoadingButton!
    
    // MARK: - ViewModel
    let viewModel = ChangePasswordViewModel(service: AuthService())
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Actions
    @IBAction func changePasswordBtnTapped(_ sender: Any) {
        if let oldPasswordText = oldPasswordTextField.text, let newPasswordText = newPasswordTextField.text, let newPasswordConfrimText = newPasswordConfrimTextField.text{
            let result = validateData(oldPasswordText: oldPasswordText, newPasswordText: newPasswordText, newPasswordConfrimText: newPasswordConfrimText)
            if result{
                viewModel.changePassword(oldPassword: oldPasswordText, newPassword: newPasswordText, newPasswordConfirm: newPasswordConfrimText)
            }
        }
    }
    
    // MARK: - Private Methods
    private func validateData(oldPasswordText: String, newPasswordText: String, newPasswordConfrimText: String) -> Bool {
        if oldPasswordText.isEmpty || newPasswordText.isEmpty || newPasswordConfrimText.isEmpty {
            message(message: "Please fill in all the required fields")
            return false
        }
        
        if newPasswordText != newPasswordConfrimText{
            message(message: "Passwords do not match")
            return false
        }
        
        if !newPasswordText.isValidPassword() {
            message(message: "Password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter.")
            return false
        }
        
        return true
    }
}

// MARK: - ChangePassword ViewModel Delegate
extension ChangePasswordVC: ChangePasswordViewModelDelegate{
    func message(message: String, isSuccess: Bool = false) {
        DispatchQueue.main.async {
            self.subtitleLabel.text = message
            self.subtitleLabel.textColor = isSuccess ? UIColor(red: 0, green: 0.5, blue: 0, alpha: 1) : UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func updateIndicator(isLoading: Bool) {
        if isLoading {
            changePasswordButton.showLoading()
        } else {
            changePasswordButton.hideLoading()
        }
    }
}


