//
//  Rating.swift
//  Propho
//
//  Created by Sofie Kedvik on 2017-09-28.
//  Copyright © 2017 Sofie Kedvik. All rights reserved.
//

import Foundation
import UIKit

class Rating: NSObject, NSCoding {
    
    var text: String
    var score: Int
    var photo: UIImage
    var date: Date
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(
            text: aDecoder.decodeObject(forKey: "text") as! String,
            score: aDecoder.decodeInteger(forKey: "score"),
            photo: aDecoder.decodeObject(forKey: "photo") as! UIImage,
            date: aDecoder.decodeObject(forKey: "date") as! Date
        )
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "text")
        aCoder.encode(score, forKey: "score")
        aCoder.encode(photo, forKey: "photo")
        aCoder.encode(date, forKey: "date")
    }
    
    init(text: String, score: Int, photo: UIImage, date: Date) {
        self.text = text
        self.score = score
        self.photo = photo
        self.date = date
        
        // have to call it self for inheritence
        super.init()
    }
}
