//
//  String+ Utils.swift
//  CS_iOS_Assignment
//
//  Created by Roderick Presswoodd on 7/2/20.
//  Copyright © 2020 Backbase. All rights reserved.
//

import Foundation

extension String {
    
    func dateFormatting() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else { return self }
        dateFormatter.dateFormat = "MMM dd, yyyy"
        return dateFormatter.string(from: date)
    }
    
    func timeLengthFormatting() -> String {
        guard let minsTotal = Int(self) else { return "0m" }
        let hours = Int(minsTotal / 60)
        let mins = minsTotal % 60
        return "\(hours)h \(mins)m"
    }
    
}
