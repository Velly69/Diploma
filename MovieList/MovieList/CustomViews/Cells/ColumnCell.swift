//
//  ColumnCell.swift
//  MovieList
//
//  Created by Alexandr Totskiy on 23.05.2022.
//

import UIKit

class ColumnCell: UICollectionViewCell {
    static var nib: UINib {
        UINib(nibName: "ColumnCell", bundle: nil)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.cornerRadius = 4
    }
    
    func setup(_ actor: PopularActor) {
        titleLabel.text = actor.name
        subtitleLabel.text = actor.name
        imageView.downloadPosterImage(fromURL: actor.profilePictureStringURL)
    }
}
