//
//  StepsViewController.swift
//  FitnessTracker
//
//  Created by Валерия Маслова on 14/06/2019.
//  Copyright © 2019 Shurumov Maxim. All rights reserved.
//

import UIKit
import HealthKit

class StepsViewController: UIViewController {
    @IBOutlet weak var stepTextField: UITextField!
    @IBOutlet weak var calTextField: UITextField!
    @IBOutlet weak var menu: UISegmentedControl!
    
    let healthManager = HealthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu.selectedSegmentIndex = 2
        
        stepTextField.isEnabled = false
        calTextField.isEnabled  = false
        
        stepTextField.text = ""
        if !healthManager.checkAuth() {

            stepTextField.text = "Device not compatible."
        }
        else {

            healthManager.fetchStepCount() { steps, success in
                DispatchQueue.main.async {
                    if success {
                        self.stepTextField.text = String(Int(steps))
                        self.calTextField.text = String(Int(round(Double(steps) * 0.042)))
                    }
                    else {
                        self.stepTextField.text = "???"
                    }
                }
            }
        }
      
        // Do any additional setup after loading the view.
    }
    @IBAction func changeSegment(_ sender: UISegmentedControl) {
        switch menu.selectedSegmentIndex {
        case 0:
            performSegue(withIdentifier: "inWeightFromWalk", sender: self)
        case 1:
            performSegue(withIdentifier: "inFoodFromWalk", sender: self)
        default:
            print("Something wrong with segmentedConrol")
        }
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
