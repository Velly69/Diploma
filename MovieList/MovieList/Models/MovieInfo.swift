//
//  Movie.swift
//  MovieList
//
//  Created by Alexander Totsky on 03.05.2022.
//

import Foundation

struct MovieInfo: Codable, Identifiable {
    let id: Int
    let title: String
    let posterPath: String
    let releaseDate: String?
    var credits: MovieCredit?
    let overview: String
    var backdropPath: String
    let genres: [MovieGenre]?
    let runtime: Int?
    let voteAverage: Double
    
    static private let yearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter
    }()
    
    var posterStringURL: String {
        return "https://image.tmdb.org/t/p/w500\(posterPath)"
    }
    
    var backdropStringURL: String {
        return "https://image.tmdb.org/t/p/w500\(backdropPath)"
    }
    
    var yearText: String {
        guard let releaseDate = self.releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return MovieInfo.yearFormatter.string(from: date)
    }
    
    var genreText: String {
        guard let genres = genres else { return "" }
        return genres.first?.name ?? "n/a"
    }
    
    var ratingText: String {
        let rating = Int(voteAverage)
        return "⭐️" + "\(rating)/10"
    }
    
    var time: String {
        guard let runtime = self.runtime, runtime > 0 else { return "n/a" }
        return "\(runtime) min"
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

struct MovieGenre: Codable, Hashable {
    let name: String
}

struct MovieCredit: Codable {
    let cast: [MovieCast]
    let crew: [MovieCrew]
}

struct MovieCast: Codable, Identifiable, Hashable {
    let id: Int
    let character: String
    let name: String
    
    let profilePath: String?
    
    var profilePictureStringURL: String {
        return "https://image.tmdb.org/t/p/w500\(profilePath ?? "")"
    }
}

struct MovieCrew: Codable, Identifiable {
    let id: Int
    let job: String
    let name: String
}
