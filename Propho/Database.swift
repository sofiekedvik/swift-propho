//
//  Database.swift
//  Propho
//
//  Created by Sofie Kedvik on 2017-09-27.
//  Copyright © 2017 Sofie Kedvik. All rights reserved.
//

import Foundation
import UIKit

private var ratings: [Rating] = {
    guard let unarchivedObject = UserDefaults.standard.value(forKey: "ratings") as? Data else { return [] }
    return NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject) as? [Rating] ?? []
}()

class Database {
    
    private static func saveRatings() {
        let data = NSKeyedArchiver.archivedData(withRootObject: ratings)
        UserDefaults.standard.setValue(data, forKey: "ratings")
        UserDefaults.standard.synchronize()
    }
    
    static var allRatings: [Rating] {
        return ratings
    }
    
    static func insert(rating: Rating) {
        ratings.append(rating)
        saveRatings()
    }
    
    static func delete(rating: Int) {
        ratings.remove(at: rating)
        saveRatings()
    }
}

