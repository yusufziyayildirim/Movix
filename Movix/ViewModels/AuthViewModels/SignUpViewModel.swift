//
//  SignUpViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 8.07.2023.
//

import Foundation

final class SignUpViewModel{
    
    // MARK: - Service
    let service: AuthServiceProtocol?
    
    // MARK: - Delegate
    weak var delegate: SignUpViewModelDelegate?
    
    // MARK: - Initialization
    init(service: AuthServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Public Methods
    func signUp(name: String, email: String, password: String, passwordConfrim: String){
        delegate?.updateIndicator(isLoading: true)
        
        service?.signUp(name: name, email: email, password: password, passwordConfrim: passwordConfrim, completion: { [weak self] result in
            guard let self = self else { return }
            
            self.delegate?.updateIndicator(isLoading: false)
            switch result {
            case .success(let response):
                if response.status ?? false {
                    self.delegate?.message(message: response.message ?? "", isSuccess: true)
                } else {
                    self.delegate?.message(message: response.message ?? "An error occurred during sign up.", isSuccess: false)
                }
            case .failure(_):
                self.delegate?.message(message: "Sign up process couldn't be completed. Please try again later.", isSuccess: false)
            }
        })
    }
}
