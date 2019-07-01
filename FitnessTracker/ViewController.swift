//
//  ViewController.swift
//  FitnessTracker
//
//  Created by Валерия Маслова on 11/06/2019.
//  Copyright © 2019 Shurumov Maxim. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var weights: Results<Weight>!
    var startData: Results<StartData>!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nowWeightTextField: UITextField!
    @IBOutlet weak var startWeightTextField: UITextField!
    @IBOutlet weak var endWeightTextField: UITextField!
    @IBOutlet weak var menu: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu.selectedSegmentIndex = 0
        menu.contentMode = .scaleAspectFit
        tableView.layer.borderWidth = 2
        tableView.layer.borderColor = UIColor.black.cgColor
        
        weights = realm.objects(Weight.self)
        startData = realm.objects(StartData.self)
        
        if(startData.isEmpty) {
            let newStartData = StartData(startWeight: 0, endWeight: 0)
            try! realm.write {
                realm.add(newStartData)
            }
        }
        
        nowWeightTextField.text = String(startData[0].nowWeight)
        startWeightTextField.text = String(startData[0].startWeight)
        endWeightTextField.text = String(startData[0].endWeight)
        
        if(weights.isEmpty) {
            let date = Date()
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let month = calendar.component(.month, from: date)
            let day = calendar.component(.day, from: date)
            let minute = calendar.component(.minute, from: date)
            let hour = calendar.component(.hour, from: date)
            let dateString = "\(day)-\(month)-\(year) \(hour):\(minute)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
            let newDate = dateFormatter.date(from: dateString)
            let newWeight = Weight(date: newDate,
                                   dateString: dateFormatter.string(from: newDate!),
                                   weight: startData[0].startWeight)
            try! realm.write {
                realm.add(newWeight)
            }
        }
        
        startWeightTextField.delegate = self
        nowWeightTextField.delegate = self
        endWeightTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {           // Количество отображаемых строк
        return weights.isEmpty ? 0 : weights.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        // Содержимое самой ячейки
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.weightLabel?.text = String(weights[indexPath.row].weight)
        cell.dateLabel?.text = weights[indexPath.row].dateString
        print(weights!.count)
        if indexPath.row != 0 {
            if weights[indexPath.row].weight < weights[indexPath.row - 1].weight {
                cell.imageOfArrow?.image = UIImage(named: "up-arrow")
            } else {
                cell.imageOfArrow?.image = UIImage(named: "down-arrow")
            }
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let weight = weights[indexPath.row]     // Выделеная ячейка
        print(indexPath.row)
        if(indexPath.row != 0) {                // Проверка на удаление первого элемента
            let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (_, _) in
                StorageManager.deleteObject(weight)
                tableView.deleteRows(at: [indexPath], with: .automatic)

                if indexPath.row == self.weights.count {
                    
                    try! realm.write {
                        self.startData[0].nowWeight = self.weights[self.weights.count - 1].weight
                        self.nowWeightTextField.text = String(self.weights[self.weights.count - 1].weight)
                    }
                }
            }

            return [deleteAction]
        }
        return nil
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            let newWeightVC = segue.destination as! NewWeightController
            
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let weight = weights[indexPath.row]
            newWeightVC.currentWeight = weight
        }

        if segue.identifier == "changeStartWeight" {
            let newWeightVC = segue.destination as! NewWeightController

            newWeightVC.startData = startData[0]
            newWeightVC.start = true
        }
        
        if segue.identifier == "changeEndWeight" {
            let newWeightVC = segue.destination as! NewWeightController
            
            newWeightVC.startData = startData[0]
            newWeightVC.end = true
        }
        
        if segue.identifier == "changeNowWeight" {
            let newWeightVC = segue.destination as! NewWeightController
            
            newWeightVC.startData = startData[0]
            newWeightVC.now = true
        }
        
        if segue.identifier == "food" {
   
            
           
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {                // Segue при возврате со страницы изменения данных
        guard let newWeightVC = segue.source as? NewWeightController else { return }
        
        newWeightVC.saveNewWeight()          // Выполняем сохранение

        if newWeightVC.currentWeight != nil {
            try! realm.write {
                startData[0].startWeight = weights[0].weight
                startData[0].nowWeight = weights[weights.count - 1].weight
            }
            startWeightTextField.text = String(weights[0].weight)
            nowWeightTextField.text = String(weights[weights.count - 1].weight)
        }
        
        if newWeightVC.currentWeight == nil {
            try! realm.write {
                startData[0].nowWeight = weights[weights.count - 1].weight
            }
            
            nowWeightTextField.text = String(weights[weights.count - 1].weight)
        }
        
        if newWeightVC.start == true {       // Если изменения были в начальном весе
            startWeightTextField.text = newWeightVC.newWeightTextField.text     // Меняем  TextField
            
            try! realm.write {               // Меняем первую строку в БД
                weights[0].weight = Double(newWeightVC.newWeightTextField.text!)!
            }
            
            if(weights.count == 1) {
                try! realm.write {
                    startData[0].nowWeight = weights[0].weight
                    nowWeightTextField.text = String(weights[0].weight)
                }
            }
  
            newWeightVC.start = false       // Убираем флаг о смене начального веса
        }
        
        if newWeightVC.now == true {        // Если изменения были в текущем весе
            nowWeightTextField.text = newWeightVC.newWeightTextField.text
            
            
            if weights.count == 1 {
                try! realm.write {
                    startData[0].startWeight = Double(newWeightVC.newWeightTextField.text!)!
                }
                startWeightTextField.text = newWeightVC.newWeightTextField.text
            }
            
            try! realm.write {               // Меняем ппоследнюю строку в БД
                weights[weights.count - 1].weight = Double(newWeightVC.newWeightTextField.text!)!
            }
            newWeightVC.now = false
        }
        
        if newWeightVC.end == true {        // Если изменения были в конечном весе
            endWeightTextField.text = newWeightVC.newWeightTextField.text
            newWeightVC.end = false
        }
        
        tableView.reloadData()              // Обновляем таблицу
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
    
    @IBAction func choiceSegment(_ sender: UISegmentedControl) {
        switch menu.selectedSegmentIndex {
            case 1:
                performSegue(withIdentifier: "food", sender: self)
            case 2:
                performSegue(withIdentifier: "inWalkFromWeight", sender: self)
            default:
                print("Something wrong with segmentedConrol")
        }
    }
}


extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === startWeightTextField {
            performSegue(withIdentifier: "changeStartWeight", sender: self)
        }
        
        if textField === nowWeightTextField {
            performSegue(withIdentifier: "changeNowWeight", sender: self)
        }
        
        if textField === endWeightTextField {
            performSegue(withIdentifier: "changeEndWeight", sender: self)
        }
    }
}
