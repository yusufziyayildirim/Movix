//
//  ImagePreviewVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 14.07.2023.
//

import UIKit

class ImagePreviewVC: UIViewController {

    // MARK: - Properties
    private let imageView = UIImageView()
    private let posterPath: String?
    
    // MARK: - Initialization
    init(posterPath: String) {
        self.posterPath = posterPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureImageView()
    }

    // MARK: - Private Methods
    private func configureImageView() {
        // Configure imageView
        self.imageView.sd_setImage(with: URL(string: ApiRoutes.imageURL(posterPath: posterPath ?? "")), placeholderImage: UIImage(named: "mainImg"))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // Pin imageView to the edges of the view
        imageView.pinToEdgesOf(view: view)
    }
}
