//
//  MovieCommentsVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 16.07.2023.
//

import UIKit

protocol MovieCommentsViewModelDelegate: AnyObject{
    func reloadTableView()
    func showErrorAlert()
    func activityIndicatorStaus(status: Bool)
}

class MovieCommentsVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var commentAddView: UIView!
    @IBOutlet weak var movieCommentsTableView: UITableView!
    @IBOutlet weak var addCommentTextField: UITextField!
    
    // MARK: - ViewModel
    let viewModel = MovieCommentsViewModel(service: MovieService())
    
    // MARK: - Properties
    let cell = MovieCommentsTableViewCell()
    var movieId = Int()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        
        configureMovieCommentsTableView()
        configureCommentAddView()
        
        viewModel.getMovieComments(movieId: movieId)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // MARK: - Actions
    @IBAction func addBtnTapped(_ sender: Any) {
        viewModel.addComment(movieId: movieId, comment: addCommentTextField.text ?? "")
    }
    
    // MARK: - Private Methods
    @objc private func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.3
        
        UIView.animate(withDuration: animationDuration) {
            self.view.frame.origin.y = -keyboardHeight
        }
    }
    
    private func configureMovieCommentsTableView() {
        movieCommentsTableView.delegate = self
        movieCommentsTableView.dataSource = self
        movieCommentsTableView.separatorInset = .zero
        movieCommentsTableView.allowsSelection = false
        movieCommentsTableView.register(cell.nib, forCellReuseIdentifier: cell.id)
    }
    
    private func configureCommentAddView() {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = UIColor.darkGray.cgColor
        borderLayer.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 0.4)
        commentAddView.layer.addSublayer(borderLayer)
    }
    
    private func createEmptyTableView() -> UIView {
        let messageLabel = UILabel()
        messageLabel.text = "The movie has no comments"
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
extension MovieCommentsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.comments.isEmpty {
            tableView.backgroundView = createEmptyTableView()
            tableView.separatorStyle = .none
            return 0
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            return  viewModel.comments.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieCommentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: cell.id, for: indexPath) as? MovieCommentsTableViewCell else {
            return UITableViewCell()
        }
        movieCommentsTableViewCell.setData(with: viewModel.comments[indexPath.row])
        
        return movieCommentsTableViewCell
    }
}

// MARK: - MovieComments ViewModel Delegate
extension MovieCommentsVC: MovieCommentsViewModelDelegate{
    func activityIndicatorStaus(status: Bool) {
        if status {
            let containerView = UIView(frame: UIScreen.main.bounds)
            containerView.backgroundColor = UIColor.systemBackground
            containerView.tag = 100
            
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.center = containerView.center
            indicator.startAnimating()
            
            DispatchQueue.main.async {
                containerView.addSubview(indicator)
                self.view.addSubview(containerView)
            }
        } else {
            DispatchQueue.main.async {
                if let containerView = self.view.subviews.first(where: { $0.tag == 100 }) {
                    containerView.removeFromSuperview()
                }
            }
        }
    }
    
    func reloadTableView() {
        movieCommentsTableView.reloadOnMainThread()
        DispatchQueue.main.async {
            self.addCommentTextField.text = ""
        }
    }
    
    func showErrorAlert() {
        let alertController = UIAlertController(title: "Error", message: "Comment could not be added, please try again later.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
