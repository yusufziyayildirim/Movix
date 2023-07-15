//
//  SeeAllVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 10.07.2023.
//

import UIKit

class SeeAllVC: UIViewController {
    
    @IBOutlet weak var movieTableView: UITableView!
    
    let viewModel = SeeAllViewModel(service: MovieService())
    var movies = [Movie]()
    
    let cell = MovieTableViewCell()
    var url = String()
    var pageTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pageTitle
        
       configureMovieTableView()
    }
    
    func configureMovieTableView() {
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.register(cell.nib, forCellReuseIdentifier: cell.id)
        
        
        viewModel.getMovies(url: url)
        
        viewModel.movies.bind { [weak self] movies in
            guard let self = self,
                  let movies = movies else {
                return
            }
            
            self.movies = movies
            movieTableView.reloadOnMainThread()
        }
    }
    
    func navigateToDetailScreen(with id: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        destinationVC.movieId = id
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}

extension SeeAllVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieTableViewCell = tableView.dequeueReusableCell(withIdentifier: cell.id, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        movieTableViewCell.setData(with: movies[indexPath.row])
        
        return movieTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToDetailScreen(with: movies[indexPath.row].id ?? 0)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY >= contentHeight - (3 * height) && viewModel.shouldDownloadMore {
            viewModel.getMovies(url: url)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let selectedMovie = self.movies[indexPath.row]
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: { () -> UIViewController? in
                let imagePreviewVC = ImagePreviewVC(posterPath: selectedMovie.posterPath ?? "")
                return imagePreviewVC
            }) { _ in
                
                let favoriteButtonViewModel = MovieActionButtonViewModel(movie: selectedMovie, status: .favoriteMovies, imageName: "star")
                let watchlistButtonViewModel = MovieActionButtonViewModel(movie: selectedMovie, status: .watchlist, imageName: "bookmark")
                let historyButtonViewModel = MovieActionButtonViewModel(movie: selectedMovie, status: .watchHistory, imageName: "checkmark.seal")

                let favoriteAction = UIAction(title: favoriteButtonViewModel.buttonTitle, image: favoriteButtonViewModel.buttonImage) { _ in
                    favoriteButtonViewModel.performAction()
                }

                let watchlistAction = UIAction(title: watchlistButtonViewModel.buttonTitle, image: watchlistButtonViewModel.buttonImage) { _ in
                    watchlistButtonViewModel.performAction()
                }

                let historyAction = UIAction(title: historyButtonViewModel.buttonTitle, image: historyButtonViewModel.buttonImage) { _ in
                    historyButtonViewModel.performAction()
                }

                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [favoriteAction, watchlistAction, historyAction])
                
            }
        return config

    }
}
