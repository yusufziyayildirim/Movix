//
//  SignInVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit

protocol SignInViewModelDelegate: AnyObject {
    func message(message: String)
    func updateIndicator(isLoading: Bool)
    func showVerifyEmailButton()
    func navigateToHomeVC()
}

final class SignInVC: UIViewController, SignInViewModelDelegate {
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var signInButton: LoadingButton!
    @IBOutlet weak var verifyEmailButton: UIButton!
    
    let viewModel = SignInViewModel(service: AuthService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        configureUI()
    }
    
    func configureUI(){
        emailTextField.addLeftIcon(UIImage(systemName: "envelope"))
        emailTextField.addShadow(opacity: 0.15, shadowRadius: 3)
        
        passwordTextField.addLeftIcon(UIImage(systemName: "lock.fill"))
        passwordTextField.addShadow(opacity: 0.15, shadowRadius: 3)
        
        signInButton.layer.cornerRadius = 10
        signInButton.clipsToBounds = true
        signInButton.addShadow(opacity: 0.2, shadowRadius: 5)
        
        verifyEmailButton.layer.cornerRadius = 10
        verifyEmailButton.clipsToBounds = true
        verifyEmailButton.isHidden = true
        verifyEmailButton.addShadow(opacity: 0.2, shadowRadius: 5)
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
        verifyEmailButton.isHidden = true
        
        if let emailText = emailTextField.text, let passwordText = passwordTextField.text {
            let result = validateData(emailText: emailText, passwordText: passwordText)
            if result {
                viewModel.signIn(email: emailText, password: passwordText)
            }
        }
    }
   
    func validateData(emailText: String, passwordText: String) -> Bool {
        if emailText.isEmpty || passwordText.isEmpty {
            message(message: "Email and password fields are required")
            return false
        }
        
        if !emailText.isValidEmail() {
            message(message: "Email is not valid")
            return false
        }
        
        return true
    }
    
    func message(message: String) {
        DispatchQueue.main.async {
            self.subtitleLabel.text = message
            self.subtitleLabel.textColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func updateIndicator(isLoading: Bool) {
        if isLoading {
            signInButton.showLoading()
        } else {
            signInButton.hideLoading()
        }
    }
    
    func showVerifyEmailButton() {
        DispatchQueue.main.async {
            self.verifyEmailButton.isHidden = false
        }
    }
    
    func navigateToHomeVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        DispatchQueue.main.async {
            guard let mainView = storyboard.instantiateInitialViewController() else { return }
            mainView.modalPresentationStyle = .fullScreen
            self.present(mainView, animated: true, completion: nil)
        }
    }
    
}
