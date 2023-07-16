//
//  ChangePasswordViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 16.07.2023.
//

import Foundation

class ChangePasswordViewModel{
    let service: AuthServiceProtocol?
    weak var delegate: ChangePasswordViewModelDelegate?
    
    init(service: AuthServiceProtocol) {
        self.service = service
    }
  
    func changePassword(oldPassword: String, newPassword: String, newPasswordConfirm: String) {
        delegate?.updateIndicator(isLoading: true)
        
        service?.changePassword(oldPassword: oldPassword, newPassword: newPassword, newPasswordConfirm: newPasswordConfirm) { result in
            self.delegate?.updateIndicator(isLoading: false)
            switch result {
            case .success(let response):
                if response.status ?? false {
                    self.delegate?.message(message: response.message ?? "", isSuccess: true)
                } else {
                    self.delegate?.message(message: response.message ?? "An error occurred while changing the password.", isSuccess: false)
                }
            case .failure(_):
                self.delegate?.message(message: "An error occurred while changing the password. Please try again later.", isSuccess: false)
            }
        }
    }
}
