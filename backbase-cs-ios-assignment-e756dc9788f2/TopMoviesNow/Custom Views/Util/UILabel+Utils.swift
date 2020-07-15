//
//  UILabel+Utils.swift
//  CS_iOS_Assignment
//
//  Created by Roderick Presswoodd on 7/2/20.
//  Copyright © 2020 Backbase. All rights reserved.
//

import UIKit

extension UILabel {
    
    convenience init(lines: Int, alignment: NSTextAlignment) {
        self.init()
        
        self.numberOfLines = lines
        self.textAlignment = alignment
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setAttrString(text: String, isBold: Bool, color: UIColor = UIColor.lightGray) {
        let font = (isBold) ? UIFont(name: "HelveticaNeue-Bold", size: 18) as Any : UIFont(name: "HelveticaNeue-Light", size: 14) as Any
        
        let attrString = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
        self.attributedText = attrString
    }
    
}
