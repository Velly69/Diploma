//
//  MovieBodyLabel.swift
//  MovieList
//
//  Created by Alexander Totsky on 08.05.2022.
//

import UIKit

class MovieBodyLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        font = UIFont.systemFont(ofSize: 16.0)
        textColor = .label
        textAlignment = .center
        adjustsFontForContentSizeCategory = true
        minimumScaleFactor = 0.25
        numberOfLines = 3
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
