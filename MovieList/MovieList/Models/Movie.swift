//
//  Movie.swift
//  MovieList
//
//  Created by Alexander Totsky on 03.05.2022.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable, Identifiable, Hashable {
    let title: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let id: Int
    
    var posterStringURL: String {
        return "https://image.tmdb.org/t/p/w500\(posterPath ?? "")"
    }
    
    var ratingText: String {
        let rating = Int(voteAverage)
        return "⭐️" + "\(rating)/10"
    }
}
