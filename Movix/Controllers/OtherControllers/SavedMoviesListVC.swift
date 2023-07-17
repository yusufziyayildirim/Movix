//
//  SavedMoviesListVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit

protocol SavedMoviesViewModelDelegate: AnyObject{
    func reloadTableView()
}

class SavedMoviesListVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var moviesTableView: UITableView!
    
    // MARK: - ViewModel
    let viewModel = SavedMoviesViewModel()
    
    // MARK: - Properties
    let cell = MovieTableViewCell()
    var status: MovieStatus = .watchlist
    var pageTitle = ""
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = pageTitle
        
        configureMovieTableView()
    }
    
    // MARK: - Private Methods
    private func configureMovieTableView() {
        moviesTableView.delegate = self
        moviesTableView.dataSource = self
        moviesTableView.register(cell.nib, forCellReuseIdentifier: cell.id)
        
        viewModel.getSavedMovies(status: status)
    }
    
    private func navigateToDetailScreen(with id: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        destinationVC.movieId = id
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    private func createEmptySearchView() -> UIView {
        let messageLabel = UILabel()
        messageLabel.text = "No saved movies available"
        messageLabel.textColor = UIColor.gray
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 17)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let emptySearchView = UIView()
        emptySearchView.addSubview(messageLabel)
        
        messageLabel.pinToEdgesOf(view: emptySearchView)
        return emptySearchView
    }
    
}

// MARK: - TableView Delegate and DataSource
extension SavedMoviesListVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.movies.isEmpty {
            tableView.backgroundView = createEmptySearchView()
            tableView.separatorStyle = .none
            return 0
        } else {
            return viewModel.movies.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieTableViewCell = tableView.dequeueReusableCell(withIdentifier: cell.id, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        movieTableViewCell.setData(with: viewModel.movies[indexPath.row])
        
        return movieTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToDetailScreen(with: viewModel.movies[indexPath.row].id ?? 0)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeMovie(with: indexPath.row, status: status)
            moviesTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let selectedMovie = viewModel.movies[indexPath.row]
        
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
                    if self.status == .favoriteMovies {
                        self.viewModel.movies.remove(at: indexPath.row)
                        self.moviesTableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
                
                let watchlistAction = UIAction(title: watchlistButtonViewModel.buttonTitle, image: watchlistButtonViewModel.buttonImage) { _ in
                    watchlistButtonViewModel.performAction()
                    if self.status == .watchlist {
                        self.viewModel.movies.remove(at: indexPath.row)
                        self.moviesTableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
                
                let historyAction = UIAction(title: historyButtonViewModel.buttonTitle, image: historyButtonViewModel.buttonImage) { _ in
                    historyButtonViewModel.performAction()
                    if self.status == .watchHistory {
                        self.viewModel.movies.remove(at: indexPath.row)
                        self.moviesTableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
                
                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [favoriteAction, watchlistAction, historyAction])
                
            }
        return config
        
    }
}

// MARK: - SavedMovies ViewModel Delegate
extension SavedMoviesListVC: SavedMoviesViewModelDelegate {
    func reloadTableView() {
        self.moviesTableView.reloadOnMainThread()
    }
}
