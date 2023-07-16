//
//  ProfileViewModel.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 16.07.2023.
//

import Foundation

class ProfileViewModel {
    let service: AuthServiceProtocol?
    weak var delegate: ProfileViewModelDelegate?
    
    init(service: AuthServiceProtocol) {
        self.service = service
    }
  
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
