//
//  StorageManager.swift
//  FitnessTracker
//
//  Created by Валерия Маслова on 11/06/2019.
//  Copyright © 2019 Shurumov Maxim. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveObject(_ weight: Weight) {
        try! realm.write {
            realm.add(weight)
        }
    }
    
    static func deleteObject(_ weight: Weight) {
        
        try! realm.write {
            realm.delete(weight)
        }
    }
    
    static func saveDish(_ dish: Dish) {
        try! realm.write {
            realm.add(dish)
        }
    }
    
    static func deleteDish(_ dish: Dish) {
        
        try! realm.write {
            realm.delete(dish)
        }
    }
    
    static func saveEatedFood(_ dish: EatedFood) {
        try! realm.write {
            realm.add(dish)
        }
    }
    
    static func deleteEatedFood(_ dish: EatedFood) {
        
        try! realm.write {
            realm.delete(dish)
        }
    }
}
