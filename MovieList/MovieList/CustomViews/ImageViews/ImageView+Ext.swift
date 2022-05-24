//
//  ImageView+Ext.swift
//  MovieList
//
//  Created by Alexandr Totskiy on 23.05.2022.
//

import Foundation
import UIKit

extension UIImageView {
    @objc func downloadPosterImage(fromURL url: String) {
        MovieNetworkManager.shared.downloadImage(from: url) { [weak self] (image) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if image != nil {
                    self.image = image
                } else {
                    self.image = UIImage(systemName: "person.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
                }
            }
        }
    }
}

