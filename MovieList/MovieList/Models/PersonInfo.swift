//
//  PersonInfo.swift
//  MovieList
//
//  Created by Alexandr Totskiy on 14.06.2022.
//

import Foundation

struct PersonInfo: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let gender: Int
    let profilePath: String?
    let biography: String
    let birthday: String
    let placeOfBirth: String
    
    var profilePictureStringURL: String {
        return "https://image.tmdb.org/t/p/w500\(profilePath ?? "")"
    }
}
