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
    
    // MARK: - Outlets
    @IBOutlet weak var homeTableView: UITableView!
    
    // MARK: - ViewModel
    let viewModel = HomeViewModel(service: MovieService())
    
    // MARK: - Properties
    let cell = MovieCollectionTableViewCell()
    
    // MARK: - View Lifecycle
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
    
    // MARK: - Private Methods
    private func configureHomeTableView() {
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.allowsSelection = false
        homeTableView.register(cell.nib, forCellReuseIdentifier: cell.id)
        homeTableView.separatorStyle = .none
        
        headerViewBind()
    }
    
    private func headerViewBind() {
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
    
    private func navigateToSeeAllScreen(row: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "SeeAllVC") as! SeeAllVC
        destinationVC.url = viewModel.sectionList[row].url
        destinationVC.pageTitle = viewModel.sectionList[row].title
        navigationController?.pushViewController(destinationVC, animated: true)

    }
    
    private func navigateToDetailScreen(with id: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        destinationVC.movieId = id
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}


// MARK: - TableView Delegate and DataSource
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

// MARK: - MovieCollectionTableViewCell Delegate
extension HomeVC: MovieCollectionTableViewCellDelegate {
    func seeAllButtonTapped(row: Int) {
        navigateToSeeAllScreen(row: row)
    }
    
    func didSelectItem(movieId: Int) {
        navigateToDetailScreen(with: movieId)
    }
}

// MARK: - Home ViewModel Delegate
extension HomeVC: HomeViewModelDelegate {
    func reloadTableView(){
        homeTableView.reloadOnMainThread()
    }
}
