//
//  SignInViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation

final class SignInViewModel{
    
    let service: AuthServiceProtocol?
    weak var delegate: SignInViewModelDelegate?
    
    init(service: AuthServiceProtocol) {
        self.service = service
    }
    
    func signIn(email: String, password: String){
        delegate?.updateIndicator(isLoading: true)
        
        service?.signIn(email: email, password: password, completion: { result in
            self.delegate?.updateIndicator(isLoading: false)
            switch result {
            case .success(let response):
                if response.status! {
                    self.delegate?.navigateToHomeVC()
                } else {
                    self.delegate?.message(message: response.message ?? "An error occurred during sign in.")
                    if response.message == "Verify e-mail address" {
                        self.delegate?.showVerifyEmailButton()
                    }
                }
            case .failure(_):
                self.delegate?.message(message: "An error occurred during sign in. Please try again later.")
            }
        })
    }
}
