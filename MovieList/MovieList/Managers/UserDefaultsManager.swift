//
//  UserDefaultsManager.swift
//  MovieList
//
//  Created by Alexander Totsky on 07.05.2022.
//

import UIKit

enum ManagerActionType {
    case add, remove
}

class UserDefaultsManager {
    private static let defaults = UserDefaults.standard
    enum Keys { static let watchLater = "watch-later" }
    
    static func update(with movieLater: Movie, actionType: ManagerActionType, completed: @escaping (MovieError?) -> ()) {
        getMoviesToWatch { (result) in
            switch result {
            case .success(var movies):
                switch actionType {
                case .add:
                    guard !movies.contains(movieLater) else {
                        completed(.alreadyExists)
                        return
                    }
                    movies.append(movieLater)
                    
                case .remove:
                    movies.removeAll { $0.id == movieLater.id }
                }
                completed(saveToDefaults(movies: movies))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getMoviesToWatch(completed: @escaping (Result<[Movie], MovieError>) -> ()) {
        guard let moviesToWatchData = defaults.object(forKey: Keys.watchLater) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let moviesToWatch = try decoder.decode([Movie].self, from: moviesToWatchData)
            completed(.success(moviesToWatch))
        } catch {
            completed(.failure(.unableToComplete))
        }
    }
    
    private static func saveToDefaults(movies: [Movie]) -> MovieError? {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(movies)
            defaults.setValue(encodedData, forKey: Keys.watchLater)
            return nil
        } catch {
            return .unableToAddToDefaults
        }
    }
}
