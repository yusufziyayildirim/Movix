//
//  HomeVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit
import SwiftUI

protocol HomeViewModelDelegate: AnyObject{
    func reloadTableView()
}

class HomeVC: UIViewController {
    
    @IBOutlet weak var homeTableView: UITableView!
    
    let cell = MovieCollectionTableViewCell()
    let viewModel = HomeViewModel(service: MovieService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeTableView()
        
        viewModel.delegate = self
        viewModel.getMovies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let tabBarController = self.tabBarController {
            if let tabBarItem = tabBarController.tabBar.items?[0] {
                let newImage = UIImage(systemName: "house.fill")
                tabBarItem.image = newImage
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let tabBarController = self.tabBarController {
            if let tabBarItem = tabBarController.tabBar.items?[0] {
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
            let carouselView = CarouselView(movies: movies){ movieId in
                self.navigateToDetailScreen(with: movieId)
            }
            
            let headerView = UIHostingController(rootView: carouselView)
            headerView.view.frame = .init(x: 0, y: 0, width: view.bounds.width, height: UIScreen.main.bounds.height * 0.5)
            homeTableView.tableHeaderView = headerView.view
        }
    }
    
    func navigateToSeeAllScreen(row: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "SeeAllVC") as! SeeAllVC
        destinationVC.url = viewModel.sectionList[row].url
        destinationVC.pageTitle = viewModel.sectionList[row].title
        navigationController?.pushViewController(destinationVC, animated: true)

    }
    
    func navigateToDetailScreen(with id: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        destinationVC.movieId = id
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}


//MARK TableView delegate and datasource
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.sectionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let homeTableViewCell = tableView.dequeueReusableCell(withIdentifier: cell.id, for: indexPath) as? MovieCollectionTableViewCell else {
            return UITableViewCell()
        }
        homeTableViewCell.delegate = self
        homeTableViewCell.row = indexPath.row
        homeTableViewCell.tableViewCellTitle.text = viewModel.sectionList[indexPath.row].title
        homeTableViewCell.setData(with: viewModel.sectionList[indexPath.row].movies)
        
        return homeTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
}

//Mark HomeTableViewCellDelegate
extension HomeVC: MovieCollectionTableViewCellDelegate {
    func seeAllButtonTapped(row: Int) {
        navigateToSeeAllScreen(row: row)
    }
    
    func didSelectItem(movieId: Int) {
        navigateToDetailScreen(with: movieId)
    }
}


extension HomeVC: HomeViewModelDelegate {
    func reloadTableView(){
        homeTableView.reloadOnMainThread()
    }
}
