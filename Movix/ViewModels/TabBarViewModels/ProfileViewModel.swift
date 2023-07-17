//
//  ProfileViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 16.07.2023.
//

import Foundation

class ProfileViewModel {
    
    // MARK: - Service
    let service: AuthServiceProtocol?
    
    // MARK: - Delegate
    weak var delegate: ProfileViewModelDelegate?
    
    // MARK: - Initialization
    init(service: AuthServiceProtocol) {
        self.service = service
    }
  
    // MARK: - Public Methods
    func signOut() {
        service?.signOut(completion: { status in
            if status {
                self.delegate?.performSignOut()
            } else {
                self.delegate?.removeLoadingView()
            }
        })
    }
}
