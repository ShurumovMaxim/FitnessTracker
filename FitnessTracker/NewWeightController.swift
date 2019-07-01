//
//  NewWeightController.swift
//  FitnessTracker
//
//  Created by Валерия Маслова on 11/06/2019.
//  Copyright © 2019 Shurumov Maxim. All rights reserved.
//

import UIKit

class NewWeightController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var newWeightTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var currentWeight: Weight?
    var startData: StartData?
    var start: Bool = false
    var end: Bool = false
    var now: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newWeightTextField.becomeFirstResponder()
        plusButton.layer.cornerRadius = 23
        plusButton.layer.borderWidth = 2
        plusButton.layer.borderColor = UIColor.white.cgColor
        
        minusButton.layer.cornerRadius = 23
        minusButton.layer.borderWidth = 2
        minusButton.layer.borderColor = UIColor.white.cgColor
        
        newWeightTextField.layer.borderWidth = 2
        newWeightTextField.layer.borderColor = UIColor.white.cgColor
        // Do any additional setup after loading the view.
        
        setupEditScreen()
    }
    
    @IBAction func addWeight(_ sender: UIButton) {
        let intWeight = Double(newWeightTextField.text!)!
        newWeightTextField.text = String(round((intWeight + 0.1) * 100) / 100)
    }
    
    @IBAction func reduceWeight(_ sender: UIButton) {
        let intWeight = Double(newWeightTextField.text!)!
        if intWeight > 0 {
            newWeightTextField.text = String(round((intWeight - 0.1) * 100) / 100)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func saveNewWeight() {
        
        let replaced = String(newWeightTextField.text!.map { $0 == "," ? "." : $0})
        newWeightTextField.text = replaced
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
        
        if currentWeight != nil {
            try! realm.write {
                currentWeight?.weight = Double(newWeightTextField.text!)!
            }
        }
        
        if start == true {
            try! realm.write {
                startData?.startWeight = Double(newWeightTextField.text!)!
            }
        }
        
        if now == true {
            try! realm.write {
                startData?.nowWeight = Double(newWeightTextField.text!)!
            }
        }
        
        if end == true {
            try! realm.write {
                startData?.endWeight = Double(newWeightTextField.text!)!
            }
        }

        if currentWeight == nil && start == false && now == false && end == false {
            let newWeight = Weight(date: newDate,
                                   dateString: dateFormatter.string(from: newDate!),
                                   weight: Double(newWeightTextField.text!)!)
            StorageManager.saveObject(newWeight)

        }
        
    }
    
    private func setupEditScreen() {
        
        setupNavigationBar()
        
        if currentWeight != nil {
            newWeightTextField.text = String(currentWeight!.weight)
        } else if start == true {
            newWeightTextField.text = String(startData!.startWeight)
        } else if now == true {
            newWeightTextField.text = String(startData!.nowWeight)
        } else if end == true {
            newWeightTextField.text = String(startData!.endWeight)
        }
    }
    
    private func setupNavigationBar() {
        
        if currentWeight != nil {
            navigationItem.leftBarButtonItem = nil
            title = currentWeight!.dateString
        } else if start == true {
            navigationItem.leftBarButtonItem = nil
            title = "Начальный вес"
        } else if now == true {
            navigationItem.leftBarButtonItem = nil
            title = "Текущий вес"
        } else if end == true {
            navigationItem.leftBarButtonItem = nil
            title = "Желанный вес"
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
