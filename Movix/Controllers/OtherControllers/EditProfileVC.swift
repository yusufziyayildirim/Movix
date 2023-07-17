//
//  EditProfileVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 16.07.2023.
//

import UIKit
import SDWebImage

protocol EditProfileViewModelDelegate: AnyObject{
    func message(message: String, isSuccess: Bool)
    func updateIndicator(isLoading: Bool)
}

class EditProfileVC: UIViewController, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: LoadingButton!
    
    // MARK: - ViewModel
    let viewModel = EditProfileViewModel(service: AuthService())
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()

        userImageView.layer.cornerRadius = 15
        viewModel.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func changePhotoBtnTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        let imagedata = userImageView.image?.jpegData(compressionQuality: 0.3)
        if let nameText = nameTextField.text {
            viewModel.editProfile(name: nameText, image: imagedata)
        } else {
            message(message: "The name filed is required")
        }
        
    }
    
    // MARK: - Private Methods
    private func setData() {
        if let url = UserSessionManager.shared.getUserImageUrl() {
            userImageView.sd_setImage(with: url)
        } else {
            userImageView.image = UIImage(named: "mainImg")
        }
        nameTextField.text = UserSessionManager.shared.getUsername()
    }
    
}

// MARK: - EditProfile ViewModel Delegate
extension EditProfileVC: EditProfileViewModelDelegate{
    func message(message: String, isSuccess: Bool = false) {
        DispatchQueue.main.async {
            self.subtitleLabel.text = message
            self.subtitleLabel.textColor = isSuccess ? UIColor(red: 0, green: 0.5, blue: 0, alpha: 1) : UIColor(red: 0.8, green: 0, blue: 0, alpha: 1)
        }
    }
    
    func updateIndicator(isLoading: Bool) {
        if isLoading {
            saveButton.showLoading()
        } else {
            saveButton.hideLoading()
        }
    }
}

// MARK: - UIImagePickerController Delegate
extension EditProfileVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImageView.image = pickedImage
        }
    }
}
