//
//  MovieInfoHeaderVC.swift
//  MovieList
//
//  Created by Alexander Totsky on 07.05.2022.
//

import UIKit

class MovieInfoMainVC: UIViewController {
    
    private let movieImageView = MovieImageView(frame: .zero)
    private let nameLabel = MovieTitleLabel(fontSize: 24, textColor: .black)
    private let releaseYearLabel = MovieTitleLabel(fontSize: 16, textColor: .black)
    
    private var movieInfo: MovieInfo!
    
    init(movieInfo: MovieInfo) {
        super.init(nibName: nil, bundle: nil)
        self.movieInfo = movieInfo
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubviews(movieImageView, nameLabel, releaseYearLabel)
        layoutUI()
        configureUI()
    }
    
    private func layoutUI() {
        let padding: CGFloat = 10
        movieImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            movieImageView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: padding),
            movieImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            movieImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            movieImageView.heightAnchor.constraint(equalToConstant: 500),
            
            releaseYearLabel.topAnchor.constraint(equalTo: movieImageView.bottomAnchor, constant: 15),
            releaseYearLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            releaseYearLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            releaseYearLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func configureUI() {
        movieImageView.downloadPosterImage(fromURL: movieInfo.posterStringURL)
        nameLabel.text = movieInfo.title
        releaseYearLabel.text = movieInfo.yearText
    }
}
