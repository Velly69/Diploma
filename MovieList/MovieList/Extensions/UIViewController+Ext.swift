//
//  UIViewController+Ext.swift
//  MovieList
//
//  Created by Alexander Totsky on 05.05.2022.
//

import UIKit

extension UIViewController {
    func showAlertVC(title: String, message: String, buttonTile: String) {
        DispatchQueue.main.async {
            let alert = MovieAlertVC(title: title, message: message, buttonTitle: buttonTile)
            alert.modalPresentationStyle = .overFullScreen
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true)
        }
    }
}
