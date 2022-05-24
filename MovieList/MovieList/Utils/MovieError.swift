//
//  MovieError.swift
//  MovieList
//
//  Created by Alexander Totsky on 04.05.2022.
//

import Foundation

enum MovieError: String, Error {
    case invalidEndpoint = "Invalid endpoint. Try again!"
    case apiError = "Failed to fetch data. Try again!"
    case unableToComplete = "Unable to complete your request. Please check your internet connection :c"
    case invalidResponse = "Invalid response from the server. Please try again!"
    case invalidData = "Invalid data from the server. Please try again!"
    case alreadyExists = "Oops, you've already added movie to watch list!"
    case unableToAddToDefaults = "There must be some troubles with adding to defaulys. Try again!"
}
