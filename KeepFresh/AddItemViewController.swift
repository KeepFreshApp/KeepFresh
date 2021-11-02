//
//  AddItemViewController.swift
//  KeepFresh
//
//  Created by Aditi Gandhi on 10/27/21.
//

import UIKit
import Parse
import Foundation

class AddItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var categoryField: UITextField!
    @IBOutlet weak var expirationDateField: UITextField!
    
    var categories = ["Dairy", "Vegetable", "Condiment", "Bakery", "Snack", "Fruit", "Protein", "Pantry", "Frozen", "Drink" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePickerView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "darkModeState") == true {
            overrideUserInterfaceStyle = .dark
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            itemNameField.backgroundColor = UIColor.darkGray
            categoryField.backgroundColor = UIColor.darkGray
            expirationDateField.backgroundColor = UIColor.darkGray
        } else {
            overrideUserInterfaceStyle = .light
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            itemNameField.backgroundColor = UIColor.white
            categoryField.backgroundColor = UIColor.white
            expirationDateField.backgroundColor = UIColor.white
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.categoryField.text = self.categories[row]
        self.categoryPicker.isHidden = true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.categoryField {
            self.categoryPicker.isHidden = false
        }
        else{
            self.categoryPicker.isHidden = true
        }
    }

    
    let datePicker = UIDatePicker()
    
    func createDatePickerView(){
        datePicker.preferredDatePickerStyle = .wheels
        
        expirationDateField.textAlignment = .center
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        expirationDateField.inputAccessoryView = toolbar
        
        expirationDateField.inputView = datePicker
        
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        expirationDateField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
    @IBAction func onAddItem(_ sender: Any) {
        let item = PFObject(className: "Grocery_Item")
        item["owner"] = PFUser.current()!.username
        
        //get Date as Date type
        item["expiryDate"] = datePicker.date
        //item["expiryDate"] = expirationDateField.text
        item["favorited"] = false
        item["category"] = categoryField.text
        item["itemName"] = itemNameField.text
        
        item.saveInBackground{(success, error) in
            if success{
                self.dismiss(animated: true, completion: nil)
                print("Saved")
            }else{
                print("error")
                print(error!)
            }
        }
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
