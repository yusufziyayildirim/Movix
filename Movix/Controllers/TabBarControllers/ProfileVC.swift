//
//  ProfileVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit
import SDWebImage

protocol ProfileViewModelDelegate: AnyObject{
    func performSignOut()
    func removeLoadingView()
}

class ProfileVC: UIViewController {
    
    @IBOutlet weak var profileTableView: UITableView!
    
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    
    let items: [[(title: String, image: String, color: UIColor?)]] = [
        [
            (title: "Edit Profile", image: "person.fill", color: UIColor(red: 0.4, green: 0.6, blue: 1.0, alpha: 1.0)),
            (title: "Change Password", image: "lock.fill", color: UIColor(red: 1.0, green: 0.4, blue: 0.0, alpha: 1.0)),
        ],
        [
            (title: "Favorites Movies", image: "star.fill", color: UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)),
            (title: "Watchlist", image: "bookmark.fill", color: UIColor(red: 0.0, green: 0.8, blue: 0.2, alpha: 1.0)),
            (title: "Watched Movies", image: "checkmark.seal.fill", color: UIColor(red: 0.6, green: 0.5, blue: 0.9, alpha: 1.0)),
        ],
        [
            (title: "Logout", image: "rectangle.portrait.and.arrow.right", color: .red)
        ]
    ]
    
    let viewModel = ProfileViewModel(service: AuthService())
    let cell = SettingsTableViewCell()
    
    var isProfilePageActive = false
    
    var loadingView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        profileTableView.backgroundColor = .systemGroupedBackground
        
        profileTableView.delegate = self
        profileTableView.dataSource = self
        
        profileTableView.separatorInset = .zero
        profileTableView.register(cell.nib, forCellReuseIdentifier: cell.id)
        
        let headerView = createHeaderView()
        profileTableView.tableHeaderView = headerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setData()
        if let tabBarController = self.tabBarController {
            if let tabBarItem = tabBarController.tabBar.items?[3] {
                let newImage = UIImage(systemName: "person.fill")
                tabBarItem.image = newImage
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !isProfilePageActive {
            if let tabBarItem = self.tabBarController?.tabBar.items?[3] {
                tabBarItem.image = UIImage(systemName: "person")
            }
        }
    }
    
    func createHeaderView() -> UIView {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: profileTableView.bounds.width, height: 80))
        headerView.backgroundColor = UIColor.secondarySystemGroupedBackground
        
        let topBorderView = UIView(frame: CGRect(x: 0, y: 0, width: headerView.bounds.width, height: 0.5))
        topBorderView.backgroundColor = UIColor.systemGray3
        headerView.addSubview(topBorderView)
        
        let bottomBorderView = UIView(frame: CGRect(x: 0, y: headerView.bounds.height - 0.1, width: headerView.bounds.width, height: 0.5))
        bottomBorderView.backgroundColor = UIColor.systemGray3
        headerView.addSubview(bottomBorderView)
        
        profileImageView.contentMode = .scaleToFill
        profileImageView.layer.cornerRadius = 10
        profileImageView.clipsToBounds = true
        headerView.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        profileImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        nameLabel.text = UserSessionManager.shared.getUsername()
        nameLabel.textColor = UIColor.label
        nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        nameLabel.textAlignment = .left
        headerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16).isActive = true
        
        return headerView
    }
    
    func setData() {
        nameLabel.text = UserSessionManager.shared.getUsername()
        if let url = UserSessionManager.shared.getUserImageUrl() {
            profileImageView.sd_setImage(with: url)
        } else {
            profileImageView.image = UIImage(named: "mainImg")
        }
    }
    
    func navigateToSavedMoviesScreen(title: String, status: MovieStatus) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "SavedMoviesListVC") as! SavedMoviesListVC
        destinationVC.status = status
        destinationVC.pageTitle = title
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func navigateToEditProfileScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        isProfilePageActive = true
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func navigateToChangePasswordScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
        isProfilePageActive = true
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func showSignOutAlert() {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        
        let logoutAction = UIAlertAction(title: "Logout", style: .destructive, handler: { [weak self] _ in
            self?.startSignOut()
        })
        alertController.addAction(logoutAction)
        
        present(alertController, animated: true, completion: nil)
    }

    func startSignOut() {
        loadingView = createLoadingView()
        view.addSubview(loadingView)
        viewModel.signOut()
    }

    private func createLoadingView() -> UIView {
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
        containerView.backgroundColor = .white
        containerView.alpha = 0.65
        
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        containerView.addSubview(activityIndicator)
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.centerYAnchor)
        ])
        
        return containerView
    }
     
   
}


extension ProfileVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let profileTableViewCell = tableView.dequeueReusableCell(withIdentifier: cell.id, for: indexPath) as? SettingsTableViewCell else {
            return UITableViewCell()
        }
        let item = items[indexPath.section][indexPath.row]
        profileTableViewCell.iconBgView.backgroundColor = item.color
        profileTableViewCell.title.text = item.title
        profileTableViewCell.icon.image = UIImage(systemName: item.image)
        if item.title == "Logout" {
            profileTableViewCell.rightIcon.isHidden = true
        }
        
        return profileTableViewCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.section][indexPath.row].title
        
        switch item {
        case "Edit Profile":
            navigateToEditProfileScreen()
            break
        case "Change Password":
            navigateToChangePasswordScreen()
            break
        case "Favorites Movies":
            navigateToSavedMoviesScreen(title: "Favorites Movies", status: .favoriteMovies)
            break
        case "Watchlist":
            navigateToSavedMoviesScreen(title: "Watchlist", status: .watchlist)
            break
        case "Watched Movies":
            navigateToSavedMoviesScreen(title: "Watched Movies", status: .watchHistory)
            break
        case "Logout":
            self.showSignOutAlert()
            break
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        
        return headerView
    }
    
}


extension ProfileVC: ProfileViewModelDelegate{
    func performSignOut() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let destinationVC = storyboard.instantiateInitialViewController()!
            
            if let scene = UIApplication.shared.connectedScenes.first,
               let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
               let window = windowSceneDelegate.window {
                window?.rootViewController = destinationVC
            }
        }
    }
    
    func removeLoadingView(){
        DispatchQueue.main.async {
            self.loadingView.removeFromSuperview()
        }
    }

}
