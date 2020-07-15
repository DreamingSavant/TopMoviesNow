//
//  MovieStruct.swift
//  CS_iOS_Assignment
//
//  Created by Roderick Presswoodd on 7/1/20.
//  Copyright © 2020 Backbase. All rights reserved.
//

import Foundation

struct MovieResults: Codable {
    var currentPage: Int
    var totalResults: Int
    var totalPages: Int
    var results: [Movie]
    
    private enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
