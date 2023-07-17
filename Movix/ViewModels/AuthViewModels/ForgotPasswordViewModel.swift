//
//  ForgotPasswordViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 9.07.2023.
//

import Foundation

final class ForgotPasswordViewModel{
    
    // MARK: - Service
    let service: AuthServiceProtocol?
    
    // MARK: - Delegate
    weak var delegate: ForgotPasswordViewModelDelegate?
    
    // MARK: - Initialization
    init(service: AuthServiceProtocol) {
        self.service = service
    }
    
    // MARK: - Public Methods
    func forgotPassword(email: String){
        delegate?.updateIndicator(isLoading: true)
        
        service?.forgotPassword(email: email, completion: { [weak self] result in
            guard let self = self else { return }
            
            self.delegate?.updateIndicator(isLoading: false)
            switch result {
            case .success(let response):
                if response.status! {
                    self.delegate?.message(message: response.message ?? "", isSuccess: true)
                } else {
                    self.delegate?.message(message: response.message ?? "An error occurred while sending the password reset email.", isSuccess: false)
                }
            case .failure(_):
                self.delegate?.message(message: "Something went wrong. Please try again later.", isSuccess: false)
            }
        })
    }
}
