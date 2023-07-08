//
//  VerifyEmailViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 9.07.2023.
//

import Foundation

final class VerifyEmailViewModel{
    
    let service: AuthServiceProtocol?
    weak var delegate: VerifyEmailViewModelDelegate?
    
    init(service: AuthServiceProtocol) {
        self.service = service
    }
    
    func verifyEmail(email: String){
        delegate?.updateIndicator(isLoading: true)
        
        service?.resendVerifyEmail(email: email, completion: { result in
            self.delegate?.updateIndicator(isLoading: false)
            switch result {
            case .success(let response):
                if response.status! {
                    self.delegate?.message(message: response.message ?? "", isSuccess: true)
                } else {
                    self.delegate?.message(message: response.message ?? "An error occurred while resending verification email.", isSuccess: false)
                }
            case .failure(_):
                self.delegate?.message(message: "Something went wrong. Please try again later.", isSuccess: false)
            }
        })
    }
}
