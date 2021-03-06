//
//  NowPlayingMoviesViewModel.swift
//  CS_iOS_Assignment
//
//  Created by Roderick Presswoodd on 7/2/20.
//  Copyright © 2020 Backbase. All rights reserved.
//

import UIKit

class NowPlayingMoviesViewModel {
  
    var service: MovieService
    var imageCache: ImageCache
    var update: (() -> ())?
    var movies: [Movie] = [] {
        didSet {
            self.update?()
        }
    }
    
    init(service: MovieService = MovieService(), cache: ImageCache = ImageCache.sharedCache) {
        self.service = service
        self.imageCache = cache
    }
    
    func bind(handler: @escaping ()->()) {
        self.update = handler
    }
    
    func fetchMovies() {
        self.service.fetchNowPlaying { (result) in
            switch result {
            case .success(let page):
                self.movies = page.results
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchIndividualFilm(index: Int, completion: @escaping ()->()) {
        if let _ = self.movies[index].duration {
            completion()
            return
        }
        
        self.service.fetchMovie(id: self.movies[index].id) { (result) in
            switch result {
            case .success(let movie):
                self.movies[index] = movie
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
      
    func fetchImage(index: Int, completion: @escaping (UIImage?) -> ()) {
        guard index < self.movies.count else {
            completion(nil)
            return
        }
        let urlString = self.fullImageURLString(for: index)
        if let data = self.imageCache.get(url: urlString) {
            print("Cache")
            completion(UIImage(data: data))
            return
        }
        completion(nil)
        self.service.fetchImage(urlString: urlString, completion: { (result) in
            switch result {
            case .success(let data):
                guard let data = data else {
                    completion(nil)
                    return
                }
                print("Network")
                self.imageCache.set(data: data, url: urlString)
                completion(UIImage(data: data))
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
}

extension NowPlayingMoviesViewModel: ViewModelType {
    
    var count: Int {
        return self.movies.count
    }
    
    func title(index: Int) -> String {
        return self.movies[index].title
    }
    
    func releaseDate(index: Int) -> String {
        return self.movies[index].releaseDate.dateFormatting()
    }
    
    func duration(index: Int) -> String {
        return String(self.movies[index].duration ?? 0).timeLengthFormatting()
    }
    
    func overView(index: Int) -> String {
        return self.movies[index].overview
    }
    
    func genres(index: Int) -> [String] {
        return self.movies[index].genres?.compactMap{ $0.name } ?? []
    }
    
    func image(index: Int) -> UIImage? {
        guard let data = self.imageCache.get(url: self.fullImageURLString(for: index)) else {
            return UIImage(named: "Default.jpeg")
        }
        return UIImage(data: data)
    }
    
    func rating(index: Int) -> Double {
        return self.movies[index].rating * 10
    }
    
    func fullImageURLString(for index: Int) -> String {
        return MovieServiceConstants.imageBaseURL + self.movies[index].posterImage
    }
    
}
