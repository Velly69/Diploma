//
//  WatchLaterCell.swift
//  MovieList
//
//  Created by Alexander Totsky on 07.05.2022.
//

import UIKit

class WatchLaterCell: UITableViewCell {
    static let reuseID = "WatchLaterCell"
    let posterImageView = MovieImageView(frame: .zero)
    let posterNameLabel = MovieTitleLabel(fontSize: 24, textColor: .black)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(movieWL: Movie) {
        posterImageView.downloadPosterImage(fromURL: movieWL.posterStringURL)
        posterNameLabel.text = movieWL.title
    }
    
    private func configureCell() {
        addSubviews(posterImageView, posterNameLabel)
        accessoryType = .disclosureIndicator
        let padding: CGFloat = 10
        
        NSLayoutConstraint.activate([
            posterImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            posterImageView.heightAnchor.constraint(equalToConstant: 150),
            posterImageView.widthAnchor.constraint(equalToConstant: 90),
            
            posterNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            posterNameLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 24),
            posterNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40),
            posterNameLabel.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
}
