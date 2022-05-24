//
//  Movie.swift
//  MovieList
//
//  Created by Alexander Totsky on 03.05.2022.
//

import Foundation

struct MovieInfo: Codable, Identifiable {
    var id: Int
    var title: String
    var posterPath: String
    var releaseDate: String?
    var credits: MovieCredit?
    let genres: [MovieGenre]? = []
    let voteAverage: Double? = 1.0
    
    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    var posterStringURL: String {
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
    
    var yearText: String {
        guard let releaseDate = self.releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return MovieInfo.yearFormatter.string(from: date)
    }
    
    var cast: [MovieCast]? {
        credits?.cast
    }
    
    var crew: [MovieCrew]? {
        credits?.crew
    }
    
    var directors: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "director" }
    }
    
    var producers: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "producer" }
    }
    
    var screenWriters: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "story" }
    }
}

struct MovieCredit: Codable {
    let cast: [MovieCast]
    let crew: [MovieCrew]
}

struct MovieCast: Codable, Identifiable {
    let id: Int
    let character: String
    let name: String
}

struct MovieCrew: Codable, Identifiable {
    let id: Int
    let job: String
    let name: String
}
