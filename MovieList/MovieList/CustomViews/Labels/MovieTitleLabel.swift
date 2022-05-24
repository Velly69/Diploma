//
//  PosterTitleLabel.swift
//  MovieList
//
//  Created by Alexander Totsky on 05.05.2022.
//

import UIKit

class MovieTitleLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fontSize: CGFloat, textColor: UIColor) {
        self.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize)
        self.textColor = textColor
    }
    
    private func configure() {
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.25
        numberOfLines = 0
        textAlignment = .center
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
