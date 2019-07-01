//
//  StartDataModel.swift
//  FitnessTracker
//
//  Created by Валерия Маслова on 12/06/2019.
//  Copyright © 2019 Shurumov Maxim. All rights reserved.
//

import RealmSwift

class StartData: Object {
    
    @objc dynamic var startWeight: Double = 0
    @objc dynamic var endWeight: Double = 0
    @objc dynamic var nowWeight: Double = 0
    
    convenience init(startWeight: Double, endWeight: Double) {
        self.init()
        self.startWeight = startWeight
        self.endWeight = endWeight
        self.nowWeight = startWeight
    }
    
}
