//
//  AvatarCell.swift
//  MovieList
//
//  Created by Alexandr Totskiy on 23.05.2022.
//

import UIKit

final class AvatarCell: UICollectionViewCell {
    static var nib: UINib {
        UINib(nibName: "AvatarCell", bundle: nil)
    }
    
    @IBOutlet weak var imageView: RoundedImageView!
    @IBOutlet weak var textLabel: UILabel!
    
    func setup(actor: PopularActor) {
        textLabel.text = actor.name
        imageView.downloadPosterImage(fromURL: actor.profilePictureStringURL)
    }
    
    func setup(cast: MovieCast) {
        textLabel.text = cast.name
        imageView.downloadPosterImage(fromURL: cast.profilePictureStringURL)
    }
}

class RoundedImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
    }
}
