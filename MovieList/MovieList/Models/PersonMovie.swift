//
//  PersonMovie.swift
//  MovieList
//
//  Created by Alexandr Totskiy on 14.06.2022.
//

import Foundation

struct PersonMovieResponse: Codable {
    let cast: [PersonMovie]
}

struct PersonMovie: Codable, Hashable {
    let title: String
    let character: String
    let id: Int
    
    let backdropPath: String?
    var backdropURL: String {
        return "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")"
    }
}
