//
//  DishModel.swift
//  FitnessTracker
//
//  Created by Валерия Маслова on 13/06/2019.
//  Copyright © 2019 Shurumov Maxim. All rights reserved.
//

import RealmSwift

class Dish: Object {
    
    @objc dynamic var imageDish: Data?
    @objc dynamic var name: String = ""
    @objc dynamic var prot: Double = 0
    @objc dynamic var fat: Double = 0
    @objc dynamic var carb: Double = 0
    @objc dynamic var sugar: Double = 0
    @objc dynamic var cal: Double = 0

    convenience init(imageDish: Data?,
                     name: String,
                     prot: Double,
                     fat: Double,
                     carb: Double,
                     sugar: Double,
                     cal: Double) {
        self.init()
        self.imageDish = imageDish
        self.name = name
        self.prot = prot
        self.fat = fat
        self.carb = carb
        self.sugar = sugar
        self.cal = cal
    }
    
}
