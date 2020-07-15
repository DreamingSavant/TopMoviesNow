//
//  ViewModelType.swift
//  CS_iOS_Assignment
//
//  Created by Roderick Presswoodd on 7/2/20.
//  Copyright © 2020 Backbase. All rights reserved.
//

import UIKit

protocol ViewModelType {
    var count: Int { get }
    func title(index: Int) -> String
    func releaseDate(index: Int) -> String
    func duration(index: Int) -> String
    func overView(index: Int) -> String
    func genres(index: Int) -> [String]
    func image(index: Int) -> UIImage?
    func rating(index: Int) -> Double
}
