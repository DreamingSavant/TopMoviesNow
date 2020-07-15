//
//  Movies.swift
//  CS_iOS_Assignment
//
//  Created by Roderick Presswoodd on 6/30/20.
//  Copyright © 2020 Backbase. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var id: Int
    var posterImage: String
    var title: String
    var rating: Double
    var duration: Int?
    var releaseDate: String
    var overview: String
    var genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres
        case releaseDate = "release_date"
        case rating = "vote_average"
        case posterImage = "poster_path"
        case duration = "runtime"
    }
}
