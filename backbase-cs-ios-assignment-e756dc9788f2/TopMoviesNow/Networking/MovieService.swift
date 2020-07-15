//
//  MovieService.swift
//  CS_iOS_Assignment
//
//  Created by Roderick Presswoodd on 7/2/20.
//  Copyright © 2020 Backbase. All rights reserved.
//

import UIKit

// TODO: Give protocol

// TODO: Fix this
enum NetworkError: Error {
    case badURL(description: String)
    case badData(description: String)
    case decodeFailure(description: String)
    case error(description: String)
}

typealias PageResultHandler = (Result<MovieResults, NetworkError>) -> ()
typealias MovieDetailHandler = (Result<Movie, NetworkError>) -> ()

class MovieService {
    
    var session: URLSession
    var decoder: JSONDecoder
    
    init(session: URLSession = URLSession.shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    func fetchNowPlaying(completion: @escaping PageResultHandler) {
        
        guard let url = URL(string: MovieServiceConstants.baseURL + MovieServiceConstants.nowPlaying + MovieServiceConstants.apiKey) else {
            completion(.failure(.badURL(description: "The URL does not work")))
            return
        }
        
        self.session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completion(.failure(.error(description: error?.localizedDescription ?? "Won't happen")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData(description: "The data is bad")))
                return
            }
            
            do {
                let result = try self.decoder.decode(MovieResults.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodeFailure(description: "The data failed to decode")))
            }
            
        }.resume()
    }
    
    func fetchPopular(with page: Int, completion: @escaping PageResultHandler) {
        
        guard let url = URL(string: MovieServiceConstants.baseURL + MovieServiceConstants.popular + MovieServiceConstants.apiKey + MovieServiceConstants.pageQuery + "\(page)") else {
            completion(.failure(.badURL(description: "The URL does not work")))
            return
        }
        
        self.session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completion(.failure(.error(description: error?.localizedDescription ?? "Won't happen")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData(description: "The data is bad")))
                return
            }
            
            do {
                let result = try self.decoder.decode(MovieResults.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodeFailure(description: "The data failed to decode")))
            }
            
        }.resume()
        
    }
    
    func fetchMovie(id: Int, completion: @escaping MovieDetailHandler) {
        
        guard let url = URL(string: MovieServiceConstants.baseURL + "\(id)" + MovieServiceConstants.apiKey) else {
            completion(.failure(.badURL(description: "The URL does not work")))
            return
        }
        
        self.session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completion(.failure(.error(description: error?.localizedDescription ?? "Won't happen")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData(description: "The data is bad")))
                return
            }
            
            do {
                let result = try self.decoder.decode(Movie.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decodeFailure(description: "The data failed to decode")))
            }
            
        }.resume()
        
    }
    
    func fetchImage(urlString: String, completion: @escaping (Result<Data?, NetworkError>)->()) {
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.badURL(description: "ssdfsdf")))
            return
        }
        
        self.session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                completion(.failure(.error(description: error?.localizedDescription ?? "Won't happen")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.badData(description: "The data is bad")))
                return
            }
            
            completion(.success(data))
            
        }.resume()
        
    }
    
}
