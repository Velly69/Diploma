//
//  PosterTitleLabel.swift
//  MovieList
//
//  Created by Alexander Totsky on 05.05.2022.
//

import UIKit

final class MovieTitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(fontSize: CGFloat, textColor: UIColor, weight: UIFont.Weight, alignment: NSTextAlignment) {
        self.init(frame: .zero)
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        self.textAlignment = alignment
        self.textColor = textColor
    }
    
    private func setup() {
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.25
        numberOfLines = 0
        textAlignment = .center
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
