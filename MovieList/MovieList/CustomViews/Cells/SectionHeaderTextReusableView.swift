//
//  SectionHeaderTextReusableView.swift
//  MovieList
//
//  Created by Alexandr Totskiy on 23.05.2022.
//

import UIKit

class SectionHeaderTextReusableView: UICollectionReusableView {
    static var nib: UINib {
        UINib(nibName: "SectionHeaderTextReusableView", bundle: nil)
    }
        
    @IBOutlet weak var titleLabel: UILabel!
}
