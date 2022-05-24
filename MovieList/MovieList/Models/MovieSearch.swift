//
//  MovieSearch.swift
//  MovieList
//
//  Created by Alexandr Totskiy on 24.05.2022.
//

import Foundation

struct MovieSearchResponse: Codable {
    let results: [MovieSearch]
}

struct MovieSearch: Codable, Identifiable, Hashable {
    var title: String
    var id: Int
}
