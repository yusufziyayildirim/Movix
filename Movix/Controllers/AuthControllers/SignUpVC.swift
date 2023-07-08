//
//  SignUpVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit

class SignUpVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfrimTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureUI()
    }

    func configureUI(){
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
    
    @IBAction func signUpBtnTapped(_ sender: Any) {
        
    }
    

}
