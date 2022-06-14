//
//  BannerCell.swift
//  MovieList
//
//  Created by Alexandr Totskiy on 23.05.2022.
//

import UIKit

final class BannerCell: UICollectionViewCell {
    
    static var nib: UINib {
        UINib(nibName: "BannerCell", bundle: nil)
    }
        
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setup(_ movie: Movie) {
        titleLabel.text = movie.title
        subtitleLabel.text = movie.ratingText
        imageView.downloadPosterImage(fromURL: movie.posterStringURL)
    }
    
    func setup(personMovie: PersonMovie) {
        titleLabel.text = personMovie.title
        subtitleLabel.text = personMovie.character
        imageView.downloadPosterImage(fromURL: personMovie.backdropURL)
    }
}
