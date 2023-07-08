//
//  ForgotPasswordVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit

class ForgotPasswordVC: UIViewController {

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    func configureUI(){
        emailTextField.addLeftIcon(UIImage(systemName: "envelope"))
        emailTextField.addShadow(opacity: 0.15, shadowRadius: 3)
        
        sendButton.layer.cornerRadius = 10
        sendButton.clipsToBounds = true
        sendButton.addShadow(opacity: 0.2, shadowRadius: 5)
    }
    
    @IBAction func sendBtnTapped(_ sender: Any) {
    }
    
}
