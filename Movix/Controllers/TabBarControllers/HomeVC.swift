//
//  HomeVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit
import SwiftUI

class HomeVC: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    let cell = HomeTableViewCell()
    let viewModel = HomeViewModel(service: MovieService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeTableView()
        
        viewModel.getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let tabBarController = self.tabBarController {
            let tabIndex = 0
            
            // TabBarItem'ı alın
            if let tabBarItem = tabBarController.tabBar.items?[tabIndex] {
                // Yeni görüntüyü oluşturun
                let newImage = UIImage(systemName: "house.fill")
                
                // Yeni görüntüyü TabBarItem'a atayın
                tabBarItem.image = newImage
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let tabBarController = self.tabBarController {
            let tabIndex = 0
            
            if let tabBarItem = tabBarController.tabBar.items?[tabIndex] {
                let newImage = UIImage(systemName: "house")
                tabBarItem.image = newImage
            }
        }
        
    }
    
    func configureHomeTableView() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.allowsSelection = false
        homeTableView.register(cell.nib, forCellReuseIdentifier: cell.id)
        homeTableView.separatorStyle = .none
        
        headerViewBind()
    }
    
    func headerViewBind() {
        viewModel.headerPosters.bind { [weak self] movies in
            guard let self = self,
                  let movies = movies else {
                return
            }
            let carouselView = CarouselView(movies: movies)
            
            let headerView = UIHostingController(rootView: carouselView)
            headerView.view.frame = .init(x: 0, y: 0, width: view.bounds.width, height: UIScreen.main.bounds.height * 0.5)
            homeTableView.tableHeaderView = headerView.view
        }
    }
}


//MARK TableView delegate and datasource
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let homeTableViewCell = tableView.dequeueReusableCell(withIdentifier: cell.id, for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        homeTableViewCell.tableViewCellTitle.text = viewModel.sectionList[indexPath.row].title
        homeTableViewCell.setData(with: viewModel.sectionList[indexPath.row].movies)
        
        return homeTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
}
