//
//  ForgotPasswordVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit

protocol ForgotPasswordViewModelDelegate: AnyObject{
    func message(message: String, isSuccess: Bool)
    func updateIndicator(isLoading: Bool)
}

class ForgotPasswordVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: LoadingButton!
    
    // MARK: - ViewModel
    let viewModel = ForgotPasswordViewModel(service: AuthService())
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        configureUI()
    }
    
    // MARK: - Actions
    @IBAction func sendBtnTapped(_ sender: Any) {
        if let emailText = emailTextField.text {
            let result = validateData(emailText: emailText)
            if result{
                viewModel.forgotPassword(email: emailText)
            }
        }
    }
    
    // MARK: - Private Methods
    private func configureUI(){
        emailTextField.addLeftIcon(UIImage(systemName: "envelope"))
        emailTextField.addShadow(opacity: 0.15, shadowRadius: 3)
        
        sendButton.layer.cornerRadius = 10
        sendButton.clipsToBounds = true
        sendButton.addShadow(opacity: 0.2, shadowRadius: 5)
    }
    
    private func validateData(emailText: String) -> Bool {
        if emailText.isEmpty {
            message(message: "Email field is required")
            return false
        }
        
        if !emailText.isValidEmail() {
            message(message: "Email is not valid")
            return false
        }
        
        return true
    }
    
}

// MARK: - ForgotPassword ViewModel Delegate
extension ForgotPasswordVC: ForgotPasswordViewModelDelegate{
    
    func message(message: String, isSuccess: Bool = false) {
        DispatchQueue.main.async {
            self.subtitleLabel.text = message
            self.subtitleLabel.textColor = isSuccess ? UIColor(red: 0, green: 0.5, blue: 0, alpha: 1) : UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func updateIndicator(isLoading: Bool) {
        if isLoading {
            sendButton.showLoading()
        } else {
            sendButton.hideLoading()
        }
    }
    
}
