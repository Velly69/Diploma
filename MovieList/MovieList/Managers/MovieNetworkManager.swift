//
//  MovieNetworkManager.swift
//  MovieList
//
//  Created by Alexander Totsky on 04.05.2022.
//

import UIKit

enum MovieListEndpoint: String {
    case upcoming = "upcoming"
    case topRated = "top_rated"
    case popular = "popular"
    
    var description: String {
        switch self {
        case .upcoming:
            return "Upcoming"
        case .topRated:
            return "Top Rated"
        case .popular:
            return "Popular"
        }
    }
}

protocol MovieService {
    func getMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
    func getMovie(id: Int, completion: @escaping (Result<MovieInfo, MovieError>) -> ())
    func getPeople(completion: @escaping (Result<PopularActorsResponse, MovieError>) -> ())
    func getPersonInfo(id: Int, completion: @escaping (Result<PersonInfo, MovieError>) -> ())
    func getPersonShows(id: Int, completion: @escaping (Result<PersonMovieResponse, MovieError>) -> ())
    func downloadImage(from urlString: String, comleted: @escaping (UIImage?) -> ())
    func searchMovies(query: String, completion: @escaping (Result<MovieResponse, MovieError>) -> ())
}

final class MovieNetworkManager {
    static let shared = MovieNetworkManager()
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "ca7fedc5050f40843d616562d625fbd8"
    private let jsonDecoder = Utils.jsonDecoder
    let cache = NSCache<NSString, UIImage>()
    
    private init () {}
    
    func getMovies(from endpoint: MovieListEndpoint, completion: @escaping (Result<MovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/movie/\(endpoint.rawValue)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        let task = URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let movieResponse = try self.jsonDecoder.decode(MovieResponse.self, from: data)
                completion(.success(movieResponse))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func getMovie(id: Int, completion: @escaping (Result<MovieInfo, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/movie/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        let params = [
            "append_to_response": "credits"
        ]
        
        queryItems.append(contentsOf: params.map {
            URLQueryItem(name: $0.key, value: $0.value)
        })
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        let task = URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let movie = try self.jsonDecoder.decode(MovieInfo.self, from: data)
                completion(.success(movie))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func getPeople(completion: @escaping (Result<PopularActorsResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/trending/person/week") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        let task = URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let actorsResponse = try self.jsonDecoder.decode(PopularActorsResponse.self, from: data)
                completion(.success(actorsResponse))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func getPersonInfo(id: Int, completion: @escaping (Result<PersonInfo, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/person/\(id)") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        let task = URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let personInfo = try self.jsonDecoder.decode(PersonInfo.self, from: data)
                completion(.success(personInfo))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func getPersonShows(id: Int, completion: @escaping (Result<PersonMovieResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/person/\(id)/movie_credits") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        let task = URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let movieResponse = try self.jsonDecoder.decode(PersonMovieResponse.self, from: data)
                completion(.success(movieResponse))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
    func downloadImage(from urlString: String, comleted: @escaping (UIImage?) -> ()) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            comleted(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            comleted(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let self = self, error == nil, let response = response as? HTTPURLResponse,
                  response.statusCode == 200, let data = data, let image = UIImage(data: data) else {
                comleted(nil)
                return
            }
            self.cache.setObject(image, forKey: cacheKey)
            comleted(image)
        }
        
        task.resume()
    }
    
    func searchMovies(query: String, completion: @escaping (Result<MovieSearchResponse, MovieError>) -> ()) {
        guard let url = URL(string: "\(baseURL)/search/movie") else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        var queryItems = [URLQueryItem(name: "api_key", value: apiKey)]
        
        let params = [
            "language": "en-US",
            "include_adult": "false",
            "region": "US",
            "query": query
        ]
        
        queryItems.append(contentsOf: params.map {
            URLQueryItem(name: $0.key, value: $0.value)
        })
        
        urlComponents.queryItems = queryItems
        
        guard let finalURL = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        let task = URLSession.shared.dataTask(with: finalURL) { (data, response, error) in
            if error != nil {
                completion(.failure(.apiError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let movie = try self.jsonDecoder.decode(MovieSearchResponse.self, from: data)
                completion(.success(movie))
            } catch {
                completion(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
}
