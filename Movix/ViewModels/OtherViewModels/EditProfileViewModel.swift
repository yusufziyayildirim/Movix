//
//  EditProfileViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 16.07.2023.
//

import Foundation

class EditProfileViewModel{
    let service: AuthServiceProtocol?
    weak var delegate: EditProfileViewModelDelegate?
    
    init(service: AuthServiceProtocol) {
        self.service = service
    }
  
    func editProfile(name: String, image: Data?) {
        delegate?.updateIndicator(isLoading: true)
        
        service?.editProfile(name: name, image: image) { result in
            self.delegate?.updateIndicator(isLoading: false)
            switch result {
            case .success(let response):
                if response.status ?? false {
                    self.delegate?.message(message: response.message ?? "", isSuccess: true)
                } else {
                    self.delegate?.message(message: response.message ?? "An error occurred during sign up.", isSuccess: false)
                }
            case .failure(_):
                self.delegate?.message(message: "An error occurred while changing the password. Please try again later.", isSuccess: false)
            }
        }
    }
}
