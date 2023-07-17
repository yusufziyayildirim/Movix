//
//  SearchVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 7.07.2023.
//

import UIKit

protocol SearchViewModelDelegate: AnyObject{
    func reloadTableView()
}

class SearchVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var resultsTitle: UILabel!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var resultsTitleView: UIView!
    
    // MARK: - Search Controller
    private let searchController: UISearchController = {
        let controller = UISearchController()
        controller.searchBar.placeholder = "Search for a Movie"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    // MARK: - ViewModel
    let viewModel = SearchViewModel(service: MovieService())
    
    // MARK: - Properties
    var movies = [Movie]()
    let cell = MovieTableViewCell()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = searchController
        viewModel.delegate = self
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        
        configureSearchResultTableView()
        addBottomBorderToView(view: resultsTitleView)
        
    }
    
    // MARK: - Actions
    @IBAction func clearBtnTapped(_ sender: Any) {
        if !viewModel.searchHistoryMovies.isEmpty{
            showClearSearchHistoryAlert()
        }
    }
    
    // MARK: - Private Methods
    private func addBottomBorderToView(view: UIView) {
        let borderLayer = CALayer()
        borderLayer.frame = CGRect(x: 0, y: view.frame.size.height - 1, width: view.frame.size.width, height: 1)
        borderLayer.backgroundColor = UIColor.systemGray.cgColor
        view.layer.addSublayer(borderLayer)
    }
    
    private func configureSearchResultTableView() {
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        searchResultsTableView.register(cell.nib, forCellReuseIdentifier: cell.id)
        
        viewModel.getSearchHistory()
        
        viewModel.movies.bind { [weak self] movies in
            guard let self = self,
                  let movies = movies else {
                return
            }
            
            self.movies = movies
            searchResultsTableView.reloadOnMainThread()
        }
    }
    
    private func showClearSearchHistoryAlert() {
        let alertController = UIAlertController(title: "Clear Search History", message: "Are you sure you want to clear your search history?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let clearAction = UIAlertAction(title: "Clear", style: .destructive) { [weak self] _ in
            self?.viewModel.clearSearchHistory()
        }
        alertController.addAction(clearAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func createEmptySearchView() -> UIView {
        let messageLabel = UILabel()
        messageLabel.text = "Movie not found"
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
    
    private func navigateToDetailScreen(with id: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailVC") as! MovieDetailVC
        destinationVC.movieId = id
        navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}

// MARK: - TableView Delegate and DataSource
extension SearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !viewModel.searchResult {
            tableView.backgroundView = createEmptySearchView()
            tableView.separatorStyle = .none
            return 0
        } else if !movies.isEmpty && viewModel.searchResult {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            return movies.count
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            return viewModel.searchHistoryMovies.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieTableViewCell = tableView.dequeueReusableCell(withIdentifier: cell.id, for: indexPath) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        if !movies.isEmpty {
            movieTableViewCell.setData(with: movies[indexPath.row])
        } else {
            movieTableViewCell.setData(with: viewModel.searchHistoryMovies[indexPath.row])
        }
        
        return movieTableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !movies.isEmpty{
            navigateToDetailScreen(with: movies[indexPath.row].id ?? 0)
            viewModel.addSearcHistory(with: movies[indexPath.row])
        } else {
            navigateToDetailScreen(with: viewModel.searchHistoryMovies[indexPath.row].id ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if movies.isEmpty{
            return true
        }
        
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.deleteSearchHistoryMovie(with: indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let selectedMovie: Movie
        if !self.movies.isEmpty {
            selectedMovie = self.movies[indexPath.row]
        } else{
            selectedMovie = viewModel.searchHistoryMovies[indexPath.row]
        }
        
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

// MARK: - UISearchController Delegate, UISearchResults Updating
extension SearchVC: UISearchControllerDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        searchResultsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3 else {
            
            resultsTitle.text = "Search History"
            viewModel.searchResult = true
            clearButton.isHidden = false
            
            viewModel.movies.value = []
            return
        }
        resultsTitle.text = "Search Results"
        viewModel.searchResult = true
        clearButton.isHidden = true
        
        viewModel.searchMovie(query: query)
    }
}

// MARK: - Search ViewModel Delegate
extension SearchVC: SearchViewModelDelegate {
    func reloadTableView() {
        searchResultsTableView.reloadOnMainThread()
    }
}
