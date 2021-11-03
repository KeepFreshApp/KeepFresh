//
//  SettingsViewController.swift
//  KeepFresh
//
//  Created by Matthew Peng on 11/1/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var notificationPeriodField: UITextField!
    @IBOutlet weak var sortByControl: UISegmentedControl!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    let defaults = UserDefaults.standard
    var darkMode : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        if defaults.bool(forKey: "darkModeState") == true {
            overrideUserInterfaceStyle = .dark
            darkModeSwitch.isOn = true
            notificationPeriodField.backgroundColor = UIColor.darkGray
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        } else {
            overrideUserInterfaceStyle = .light
            notificationPeriodField.backgroundColor = UIColor.white
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        }
        notificationPeriodField.text = String(defaults.integer(forKey: "NotifyDays"))
        sortByControl.selectedSegmentIndex = defaults.integer(forKey: "Sortby")
    }

    override func viewWillDisappear(_ animated: Bool) {
        defaults.set(sortByControl.selectedSegmentIndex, forKey: "Sortby")
        defaults.set(Int(notificationPeriodField.text!), forKey: "NotifyDays")
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func onDarkModeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            darkMode = "true"
            defaults.set(true, forKey: "darkModeState")
            overrideUserInterfaceStyle = .dark
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            notificationPeriodField.backgroundColor = UIColor.darkGray
        } else {
            darkMode = "false"
            defaults.set(false, forKey: "darkModeState")
            overrideUserInterfaceStyle = .light
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            notificationPeriodField.backgroundColor = UIColor.white
        }
        defaults.synchronize()
    }
}
