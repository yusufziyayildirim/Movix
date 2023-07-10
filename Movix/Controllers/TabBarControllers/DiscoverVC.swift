//
//  DiscoverVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit
import SwiftUI

class DiscoverVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let discoverView = UIHostingController(rootView: DiscoverView())
        discoverView.view.frame = view.frame
        
        addChild(discoverView)
        view.addSubview(discoverView.view)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        if let tabBarController = self.tabBarController {
            let tabIndex = 1
            
            // TabBarItem'ı alın
            if let tabBarItem = tabBarController.tabBar.items?[tabIndex] {
                // Yeni görüntüyü oluşturun
                let newImage = UIImage(systemName: "flashlight.on.fill")
                
                // Yeni görüntüyü TabBarItem'a atayın
                tabBarItem.image = newImage
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let tabBarController = self.tabBarController {
            let tabIndex = 1
            
            // TabBarItem'ı alın
            if let tabBarItem = tabBarController.tabBar.items?[tabIndex] {
                // Yeni görüntüyü oluşturun
                let newImage = UIImage(systemName: "flashlight.off.fill")
                
                // Yeni görüntüyü TabBarItem'a atayın
                tabBarItem.image = newImage
            }
        }
    }

}
