//
//  PopularActor.swift
//  MovieList
//
//  Created by Alexandr Totskiy on 23.05.2022.
//

import Foundation

struct PopularActorsResponse: Codable {
    let results: [PopularActor]
    
    var actors: [PopularActor] {
        results.filter { $0.knownForDepartment.lowercased() == "acting" }
    }
    
    var directors: [PopularActor] {
        results.filter { $0.knownForDepartment.lowercased() == "directing" }
    }
}

struct PopularActor: Codable, Hashable, Identifiable {
    var id: Int
    let name: String
    let knownForDepartment: String
    let profilePath: String?
    
    var profilePictureStringURL: String {
        return "https://image.tmdb.org/t/p/w500\(profilePath ?? "")"
    }
}
