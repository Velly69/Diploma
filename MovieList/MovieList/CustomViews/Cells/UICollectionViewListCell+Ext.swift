//
//  UICollectionViewListCell.swift
//  MovieList
//
//  Created by Alexandr Totskiy on 23.05.2022.
//

import UIKit

extension UICollectionViewListCell {
    func setup(movie: MovieSearch) {
        var content = defaultContentConfiguration()
        content.text = movie.title
        content.image = UIImage(systemName: "film")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        content.imageProperties.maximumSize = .init(width: 60, height: 60)
        content.imageProperties.cornerRadius = 30
        contentConfiguration = content
    }
}
