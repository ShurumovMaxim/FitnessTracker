//
//  FoodViewController.swift
//  FitnessTracker
//
//  Created by Валерия Маслова on 13/06/2019.
//  Copyright © 2019 Shurumov Maxim. All rights reserved.
//

import UIKit
import RealmSwift

class DishesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var dishes: Results<Dish>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.layer.borderWidth = 2
        tableView.layer.borderColor = UIColor.black.cgColor
        dishes = realm.objects(Dish.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eatDish" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let dish = dishes[indexPath.row]
            
            let newDishVC = segue.destination as! NewDishViewController
            newDishVC.imageIsChanged = true
            newDishVC.currentDish = dish
        }
    }
    
    
     @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {

        guard let newDishVC = segue.source as? NewDishViewController else { return }
        newDishVC.saveNewDish()
        tableView.reloadData()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension DishesViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishes.isEmpty ? 0 : dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Dish", for: indexPath) as! DishCell

        let dish = dishes[indexPath.row]
        
        cell.foodImage.image = UIImage(data: dish.imageDish!)
        cell.foodImage.layer.cornerRadius = (cell.foodImage.frame.size.height + 1) / 2
        print(String(Double(cell.foodImage.layer.cornerRadius)) + " NEW" )
        cell.foodImage.clipsToBounds = true
        
        cell.nameLabel.text = dish.name
        cell.protLabel.text = String(dish.prot)
        cell.fatLabel.text = String(dish.fat)
        cell.carbLabel.text = String(dish.carb)
        cell.sugarLabel.text = String(dish.sugar)
        cell.calLabel.text = String(dish.cal)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let dish = dishes[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_,_) in
            
            StorageManager.deleteDish(dish)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }
}
