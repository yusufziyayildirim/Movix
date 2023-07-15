//
//  ImagePreviewVC.swift
//  Movix
//
//  Created by Yusuf Ziya YILDIRIM on 14.07.2023.
//

import UIKit

class ImagePreviewVC: UIViewController {

    private let imageView = UIImageView()
    private let posterPath: String?
    
    init(posterPath: String) {
        self.posterPath = posterPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.sd_setImage(with: URL(string: ApiRoutes.imageURL(posterPath: posterPath ?? "")), placeholderImage: UIImage(named: "mainImg"))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.pinToEdgesOf(view: view)
    }

}
