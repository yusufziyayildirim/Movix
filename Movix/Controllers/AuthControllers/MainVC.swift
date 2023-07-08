//
//  MainVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI(){
        mainImg.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        mainImg.addShadow(opacity: 0.8, shadowRadius: 20)
        
        registerButton.addShadow(opacity: 0.2, shadowRadius: 5)
        loginButton.addShadow(opacity: 0.2, shadowRadius: 5)
    }

}
