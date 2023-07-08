//
//  SignInVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit

class SignInVC: UIViewController {

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var verifyEmailButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()

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
        verifyEmailButton.isHidden = false
        verifyEmailButton.addShadow(opacity: 0.2, shadowRadius: 5)
    }
    
    @IBAction func signInButtonTapped(_ sender: Any) {
    }
    
    @IBAction func verifyEmailButton(_ sender: Any) {
    }
    
}
