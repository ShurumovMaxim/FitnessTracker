//
//  DishViewController.swift
//  FitnessTracker
//
//  Created by Валерия Маслова on 13/06/2019.
//  Copyright © 2019 Shurumov Maxim. All rights reserved.
//

import UIKit
import RealmSwift

class FoodViewController: UIViewController {
    
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var protLabel: UILabel!
    @IBOutlet weak var fatLabel: UILabel!
    @IBOutlet weak var carbLabel: UILabel!
    @IBOutlet weak var sugarLabel: UILabel!
    @IBOutlet weak var calLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var menu: UISegmentedControl!
    
    var eatedFood: Results<EatedFood>!
    
    var dates: Set<Date> = []
    var arrayDates: Array<Date> = []
    var setEatedFood: Set<EatedFood> = []
    var arrayEatedFood: Array<EatedFood> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let dateString = "\(day)-\(month)-\(year)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let nowDate = dateFormatter.date(from: dateString)
        
        dateLabel.text = dateFormatter.string(from: nowDate!)
        
        protLabel.text = "0"
        fatLabel.text = "0"
        carbLabel.text = "0"
        sugarLabel.text = "0"
        calLabel.text = "0"
        
        menu.selectedSegmentIndex = 1
        
        foodTableView.layer.borderWidth = 2
        foodTableView.layer.borderColor = UIColor.black.cgColor
        
        historyTableView.layer.borderWidth = 2
        historyTableView.layer.borderColor = UIColor.black.cgColor
        
        eatedFood = realm.objects(EatedFood.self)
    }
    
    @IBAction func unwindToFood(_ segue: UIStoryboardSegue) {
        
        guard segue.identifier == "backToFood" else { return }
        
        guard let newDishVC = segue.source as? NewDishViewController else { return }
        
        newDishVC.eatDish()
        foodTableView.reloadData()
        historyTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "add" {

        }
    }
    
    
    @IBAction func add(_ sender: UIBarButtonItem) {
         performSegue(withIdentifier: "add", sender: nil)
    }

    @IBAction func choiceSegment(_ sender: UISegmentedControl) {
        switch menu.selectedSegmentIndex {
        case 0:
            performSegue(withIdentifier: "inWeightFromFood", sender: self)
        case 2:
            performSegue(withIdentifier: "inWalkFromFood", sender: self)
        default:
            print("Something wrong with segmentedConrol")
        }
    }
}

extension FoodViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var countEatedFood = 0
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let dateString = "\(day)-\(month)-\(year)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        
        let nowDate = dateFormatter.date(from: dateString)
        
        dateLabel.text = dateFormatter.string(from: nowDate!)
        
        protLabel.text = "0"
        fatLabel.text = "0"
        carbLabel.text = "0"
        sugarLabel.text = "0"
        calLabel.text = "0"
        
        dates.removeAll()
        setEatedFood.removeAll()
        
        for eatFood in eatedFood {
            if nowDate == eatFood.date {
                countEatedFood += 1
                protLabel.text = String(Double(protLabel.text!)! + eatFood.prot)
                fatLabel.text = String(Double(fatLabel.text!)! + eatFood.fat)
                carbLabel.text = String(Double(carbLabel.text!)! + eatFood.carb)
                sugarLabel.text = String(Double(sugarLabel.text!)! + eatFood.sugar)
                calLabel.text = String(Double(calLabel.text!)! + eatFood.cal)
                setEatedFood.insert(eatFood)
            }
            dates.insert(eatFood.date!)
        }
        arrayEatedFood.removeAll()
        arrayEatedFood = Array(setEatedFood)
        
        arrayDates.removeAll()
        arrayDates = Array(dates)
        arrayDates = arrayDates.sorted()
        
        if tableView === foodTableView {
            return countEatedFood
        } else {
            return arrayDates.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === foodTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EatedFood", for: indexPath) as! EatedFoodCell
            
            let date = Date()
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            
            let dateString = "\(day)-\(month)-\(year)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            
            let nowDate = dateFormatter.date(from: dateString)
            var food = EatedFood()
            for eatFood in eatedFood {
                if nowDate == eatFood.date! {
                    food = arrayEatedFood[indexPath.row]
                    break
                }
            }
        
            cell.foodView.image = UIImage(data: food.imageDish!)
            cell.foodView.layer.cornerRadius = cell.foodView.frame.size.height / 2
            cell.foodView.clipsToBounds = true
            
            cell.nameLabel.text = food.name
            cell.grammLabel.text = String(food.gramm)
            cell.protLabel.text = String(food.prot)
            cell.fatLabel.text = String(food.fat)
            cell.carbLabel.text = String(food.carb)
            cell.sugarLabel.text = String(food.sugar)
            cell.calLabel.text = String(food.cal)
            return cell
        }
        else if tableView == historyTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell",
                                                     for: indexPath) as! HistoryCell

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"

            
            cell.dateLabel.text = dateFormatter.string(from: arrayDates[indexPath.row])
            cell.protLabel.text = "0"
            cell.fatLabel.text = "0"
            cell.carbLabel.text = "0"
            cell.sugarLabel.text = "0"
            cell.calLabel.text = "0"
            for eatFood in eatedFood {
                if eatFood.date == arrayDates[indexPath.row] {
                    
                   
                    cell.protLabel.text = String(Double(cell.protLabel.text!)! + eatFood.prot)
                    cell.fatLabel.text = String(Double(cell.fatLabel.text!)! + eatFood.fat)
                    cell.carbLabel.text = String(Double(cell.carbLabel.text!)! + eatFood.carb)
                    cell.sugarLabel.text = String(Double(cell.sugarLabel.text!)! + eatFood.sugar)
                    cell.calLabel.text = String(Double(cell.calLabel.text!)! + eatFood.cal)
                }
            }
            
            return cell
        }
        return UITableViewCell()
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let food = eatedFood[indexPath.row]
        if tableView === foodTableView {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "EatedFood",
//                                                     for: indexPath) as! EatedFoodCell
//            var food = EatedFood()
//            for eatFood in eatedFood {
//                print("???" + cell.protLabel.text!)
//                if String(eatFood.prot) == cell.protLabel.text! && String(eatFood.fat) == cell.fatLabel.text!{
//                    food = eatFood
//                    print("????!!!!")
//                    break
//                }
//            }
//            print("???!!!")
            
            let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_,_) in

                StorageManager.deleteEatedFood(food)
               // print("???!!!")
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.historyTableView.reloadData()  
            }
            return [deleteAction]
        }
        return nil
    }
}
