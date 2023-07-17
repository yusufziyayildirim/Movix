//
//  EditProfileViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 16.07.2023.
//

import Foundation

class EditProfileViewModel{
    
    // MARK: - Service
    let service: AuthServiceProtocol?
    
    // MARK: - Delegate
    weak var delegate: EditProfileViewModelDelegate?
    
    // MARK: - Initialization
    init(service: AuthServiceProtocol) {
        self.service = service
    }
  
    // MARK: - Public Methods
    func editProfile(name: String, image: Data?) {
        delegate?.updateIndicator(isLoading: true)
        
        service?.editProfile(name: name, image: image) { [weak self] result in
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
                self.delegate?.message(message: "An error occurred while changing the password. Please try again later.", isSuccess: false)
            }
        }
    }
}
