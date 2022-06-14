//
//  MovieCell.swift
//  MovieList
//
//  Created by Alexander Totsky on 04.05.2022.
//

import UIKit

final class MovieCell: UICollectionViewCell {
    static let reuseID = "MovieCell"
    let posterImageView = MovieImageView(frame: .zero)
    let movieNameLabel = MovieTitleLabel(fontSize: 24, textColor: .black, weight: .regular, alignment: .center)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(movie: Movie) {
        //posterImageView.downloadPosterImage(fromURL: movie.posterStringURL)
        movieNameLabel.text = movie.title
    }
    
    private func setupCell() {
        addSubviews(posterImageView, movieNameLabel)
        
        let padding: CGFloat = 8
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            posterImageView.heightAnchor.constraint(equalToConstant: 600),
            
            movieNameLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 12),
            movieNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            movieNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            movieNameLabel.heightAnchor.constraint(equalToConstant: 40),
            movieNameLabel.widthAnchor.constraint(equalToConstant: 400)
        ])
    }
}
