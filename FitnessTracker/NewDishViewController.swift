//
//  NewDishViewController.swift
//  FitnessTracker
//
//  Created by Валерия Маслова on 13/06/2019.
//  Copyright © 2019 Shurumov Maxim. All rights reserved.
//

import UIKit

class NewDishViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var protTextField: UITextField!
    @IBOutlet weak var fatTextField: UITextField!
    @IBOutlet weak var carbTextField: UITextField!
    @IBOutlet weak var sugarTextField: UITextField!
    @IBOutlet weak var calTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var grammTextField: UITextField!
    @IBOutlet weak var eatButton: UIButton!
    @IBOutlet weak var grammLabel: UILabel!
    
    var currentDish: Dish?

    var imageIsChanged = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(imageTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        eatButton.layer.borderWidth = 2
        eatButton.layer.borderColor = UIColor.black.cgColor
        
        saveButton.isEnabled = false
        eatButton.isEnabled = false
        nameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        protTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        fatTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        carbTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        sugarTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        calTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        grammTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func saveNewDish() {
        
        var image: UIImage?
        
        if(imageIsChanged == true) {
            image = imageView.image
        } else {
            image = #imageLiteral(resourceName: "dish")
        }
        
        let imageData = image?.pngData()
        
        var replaced = String(protTextField.text!.map { $0 == "," ? "." : $0})
        protTextField.text = replaced
        replaced = String(fatTextField.text!.map { $0 == "," ? "." : $0})
        fatTextField.text = replaced
        replaced = String(carbTextField.text!.map { $0 == "," ? "." : $0})
        carbTextField.text = replaced
        replaced = String(sugarTextField.text!.map { $0 == "," ? "." : $0})
        sugarTextField.text = replaced
        replaced = String(calTextField.text!.map { $0 == "," ? "." : $0})
        calTextField.text = replaced
        
        let newDish = Dish(imageDish: imageData,
                           name: nameTextField.text!,
                           prot: Double(protTextField.text!)!,
                           fat: Double(fatTextField.text!)!,
                           carb: Double(carbTextField.text!)!,
                           sugar: Double(sugarTextField.text!)!,
                           cal: Double(calTextField.text!)!)
        if currentDish != nil {
            try! realm.write {
                currentDish?.imageDish = newDish.imageDish
                currentDish?.name = newDish.name
                currentDish?.prot = newDish.prot
                currentDish?.fat = newDish.fat
                currentDish?.carb = newDish.carb
                currentDish?.sugar = newDish.sugar
                currentDish?.cal = newDish.cal
                
            }
        } else {
            StorageManager.saveDish(newDish)
        }
    }
    
    private func setupEditScreen() {
        if currentDish != nil {
            guard let data = currentDish?.imageDish, let image = UIImage(data: data) else { return }
            
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            nameTextField.text = currentDish!.name
            protTextField.text = String(currentDish!.prot)
            fatTextField.text = String(currentDish!.fat)
            carbTextField.text = String(currentDish!.carb)
            sugarTextField.text = String(currentDish!.sugar)
            calTextField.text = String(currentDish!.cal)
            
            setupNavigationBar()
        } else {
            eatButton.isHidden = true
            grammTextField.isHidden = true
            grammLabel.isHidden = true
        }
    }
    
    private func setupNavigationBar() {
        title = "Блюдо"
        saveButton.isEnabled = true
    }
    
    func eatDish() {
        
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        let dateString = "\(day)-\(month)-\(year)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let newDate = dateFormatter.date(from: dateString)
        
        var image: UIImage?
        
        if(imageIsChanged == true) {
            image = imageView.image
        } else {
            image = #imageLiteral(resourceName: "dish")
        }
        
        let imageData = image?.pngData()
        
        let newEatedFood = EatedFood(imageDish: imageData,
                                     name: nameTextField.text!,
                                     prot: Double(protTextField.text!)! * (Double(grammTextField.text!)! / Double(100)),
                                     fat: Double(fatTextField.text!)! * (Double(grammTextField.text!)! / Double(100)),
                                     carb: Double(carbTextField.text!)! * (Double(grammTextField.text!)! / Double(100)),
                                     sugar: Double(sugarTextField.text!)! * (Double(grammTextField.text!)! / Double(100)),
                                     cal: Double(calTextField.text!)! * (Double(grammTextField.text!)! / Double(100)),
                                     date: newDate,
                                     gramm: Int(grammTextField.text!)! )
        StorageManager.saveEatedFood(newEatedFood)
    }

    @IBAction func backToFood(_ sender: UIButton) {
        performSegue(withIdentifier: "backToFood", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "backToDishes" {
//            let foodVC = segue.destination as! FoodViewController
//            if foodVC.calLabel.text == "0" {
//                foodVC.calLabel.text = calTextField.text
//            }
//
//        }
    }
    
    
    
}

extension NewDishViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.editedImage] as? UIImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageIsChanged = true
        dismiss(animated: true, completion: nil)
    }
}

extension NewDishViewController: UITextFieldDelegate {
    
    @objc private func textFieldChanged() {
        
        if(protTextField.text?.isEmpty == false &&
            nameTextField.text?.isEmpty == false &&
            fatTextField.text?.isEmpty == false &&
            carbTextField.text?.isEmpty == false &&
            sugarTextField.text?.isEmpty == false &&
            calTextField.text?.isEmpty == false) {
            
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
        
        if(grammTextField.text?.isEmpty == false) {
            eatButton.isEnabled = true
        } else {
            eatButton.isEnabled = false
        }
    }
}

extension NewDishViewController {
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        
        //let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        let cameraIcon = #imageLiteral(resourceName: "camera")
        let photoIcon = #imageLiteral(resourceName: "photo")
        
        let actionSheet = UIAlertController(title: nil,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera",
                                   style: .default) { _ in
                                    self.chooseImagePicker(source: .camera)
        }
        camera.setValue(cameraIcon, forKey: "Image")
        
        let photo = UIAlertAction(title: "Photo",
                                  style: .default) { _ in
                                    self.chooseImagePicker(source: .photoLibrary)
        }
        photo.setValue(photoIcon, forKey: "Image")
        
        let cancel = UIAlertAction(title: "Cancel",
                                   style: .cancel)
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet,animated: true)
    }
}
