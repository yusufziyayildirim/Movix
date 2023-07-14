//
//  DiscoverVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit
import SwiftUI

protocol DiscoverViewModelDelegate: AnyObject {
    func navigateToDetailScreen(with id: Int)
}


class DiscoverVC: UIViewController {

    let viewModel = DiscoverViewModel(service: MovieService())
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        let discoverView = UIHostingController(rootView: DiscoverView().environmentObject(viewModel))
        discoverView.view.frame = view.frame
        
        addChild(discoverView)
        view.addSubview(discoverView.view)
        self.title = "Discover"
    }
    

    override func viewWillAppear(_ animated: Bool) {
        if let tabBarController = self.tabBarController {
            if let tabBarItem = tabBarController.tabBar.items?[1] {
                let newImage = UIImage(systemName: "flashlight.on.fill")
                tabBarItem.image = newImage
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let tabBarController = self.tabBarController {
            if let tabBarItem = tabBarController.tabBar.items?[1] {
                let newImage = UIImage(systemName: "flashlight.off.fill")
                tabBarItem.image = newImage
            }
        }
    }
   
}


extension DiscoverVC: DiscoverViewModelDelegate {
    func navigateToDetailScreen(with id: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        destinationVC.movieId = id
        navigationController?.pushViewController(destinationVC, animated: true)
    }
}
