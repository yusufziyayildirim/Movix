//
//  SignUpVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit

protocol SignUpViewModelDelegate: AnyObject {
    func message(message: String, isSuccess: Bool)
    func updateIndicator(isLoading: Bool)
}

class SignUpVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var passwordConfrimTextField: PasswordTextField!
    @IBOutlet weak var signUpButton: LoadingButton!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    // MARK: - ViewModel
    let viewModel = SignUpViewModel(service: AuthService())
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        configureUI()
    }
    
    // MARK: - Actions
    @IBAction func signUpBtnTapped(_ sender: Any) {
        if let nameText = nameTextField.text, let emailText = emailTextField.text, let passwordText = passwordTextField.text, let passwordConfrimText = passwordConfrimTextField.text{
            let result = validateData(nameText: nameText, emailText: emailText, passwordText: passwordText, passwordConfrimText: passwordConfrimText)
            if result{
                viewModel.signUp(name: nameText, email: emailText, password: passwordText, passwordConfrim: passwordConfrimText)
            }
        }
    }
    
    // MARK: - Private Methods
    private func configureUI(){
        nameTextField.addLeftIcon(UIImage(systemName: "person"))
        nameTextField.addShadow(opacity: 0.15, shadowRadius: 3)
        
        emailTextField.addLeftIcon(UIImage(systemName: "envelope"))
        emailTextField.addShadow(opacity: 0.15, shadowRadius: 3)
        
        passwordTextField.addLeftIcon(UIImage(systemName: "lock.fill"))
        passwordTextField.addShadow(opacity: 0.15, shadowRadius: 3)
        
        passwordConfrimTextField.addLeftIcon(UIImage(systemName: "lock.fill"))
        passwordConfrimTextField.addShadow(opacity: 0.15, shadowRadius: 3)
        
        signUpButton.layer.cornerRadius = 10
        signUpButton.clipsToBounds = true
        signUpButton.addShadow(opacity: 0.2, shadowRadius: 5)
    }
    
    private func validateData(nameText: String, emailText: String, passwordText: String, passwordConfrimText: String) -> Bool {
        if nameText.isEmpty || emailText.isEmpty || passwordText.isEmpty || passwordConfrimText.isEmpty {
            message(message: "Please fill in all the required fields")
            return false
        }
        
        if !emailText.isValidEmail() {
            message(message: "Email is not valid")
            return false
        }
        
        if passwordText != passwordConfrimText{
            message(message: "Passwords do not match")
            return false
        }
        
        if !passwordText.isValidPassword() {
            message(message: "Password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter.")
            return false
        }
        
        return true
    }
}

// MARK: - SignUp ViewModel Delegate
extension SignUpVC: SignUpViewModelDelegate{
    
    func message(message: String, isSuccess: Bool = false) {
        DispatchQueue.main.async {
            self.subtitleLabel.text = message
            self.subtitleLabel.textColor = isSuccess ? UIColor(red: 0, green: 0.5, blue: 0, alpha: 1) : UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func updateIndicator(isLoading: Bool) {
        if isLoading {
            signUpButton.showLoading()
        } else {
            signUpButton.hideLoading()
        }
    }
    
}
