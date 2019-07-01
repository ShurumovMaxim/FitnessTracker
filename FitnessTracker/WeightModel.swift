//
//  WeightModel.swift
//  FitnessTracker
//
//  Created by Валерия Маслова on 11/06/2019.
//  Copyright © 2019 Shurumov Maxim. All rights reserved.
//

import RealmSwift

class Weight: Object {
    
    @objc dynamic var date: Date?
    @objc dynamic var dateString: String = ""
    @objc dynamic var weight: Double = 0
    
    convenience init(date: Date?, dateString: String, weight: Double) {
        self.init()
        self.date = date
        self.dateString = dateString
        self.weight = weight
    }

}

