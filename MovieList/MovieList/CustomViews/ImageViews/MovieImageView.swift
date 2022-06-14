//
//  PosterImageView.swift
//  MovieList
//
//  Created by Alexander Totsky on 05.05.2022.
//

import UIKit

final class MovieImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        clipsToBounds = true
        contentMode = .scaleAspectFit
        translatesAutoresizingMaskIntoConstraints = false
    }
}
