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
    var title: String
    var posterPath: String = ""
    var backdropPath: String?
    //let overview: String?
    let voteAverage: Double
    var id: Int
    //let runtime: Int?
    
    let genres: [MovieGenre]?
    
    var posterStringURL: String {
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
    
    var backdropURL: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)")!
    }
    
    var genreText: String {
        genres?.first?.name ?? "n/a"
    }
    
    var ratingText: String {
        let rating = Int(voteAverage)
        return "⭐️" + "\(rating)/10"
    }
}

struct MovieGenre: Codable, Hashable {
    let name: String
}
