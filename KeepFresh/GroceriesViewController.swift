//
//  GroceriesViewController.swift
//  KeepFresh
//
//  Created by Albert Ai on 10/27/21.
//

import UIKit
import Parse

class GroceriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var groceriesTableView: UITableView!
    
    var items = [PFObject]()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groceriesTableView.delegate = self
        groceriesTableView.dataSource = self
        print("here")
        print(settings.darkMode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let query = PFQuery(className: "Grocery_Item")
        query.whereKey("owner", equalTo: PFUser.current()!.username!)
        if (defaults.integer(forKey: "sortBy") == 0) {
            query.order(byAscending: "createdAt")
        } else {
            query.order(byAscending: "expiryDate")
        }
        query.findObjectsInBackground { (items, error) in
            if (items != nil) {
                self.items = items!
                self.groceriesTableView.reloadData()
            }
        }
      
        if defaults.bool(forKey: "darkModeState") == true {
            overrideUserInterfaceStyle = .dark
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            tabBarController?.tabBar.unselectedItemTintColor = UIColor.white
        } else {
            overrideUserInterfaceStyle = .light
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            tabBarController?.tabBar.unselectedItemTintColor = UIColor.gray
        }
    }
  
    @IBAction func onLogoutButton(_ sender: Any) {
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let delegate = windowScene.delegate as? SceneDelegate else {return}
        
        delegate.window?.rootViewController = loginViewController
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groceriesTableView.dequeueReusableCell(withIdentifier: "GroceryItemCell", for: indexPath) as! GroceryItemCell
        cell.backgroundColor = UIColor.black
        let item = items[indexPath.row]
        
        cell.itemNameLabel.text = item["itemName"] as? String
        cell.categoryLabel.text = item["category"] as? String
        cell.itemId = item.objectId
        
        var expirationDate: Date
        if (defaults.integer(forKey: "sortBy") == 0) {
            expirationDate = items[indexPath.row].createdAt!
        } else {
            expirationDate = items[indexPath.row]["expiryDate"] as! Date
        }
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "M/d/yyyy, h:mm a"
        let dateFormatterOut = DateFormatter()
        dateFormatterOut.dateFormat = "MMM d, yyyy"
        let date: Date? = dateFormatterGet.date(from: expirationDate.formatted())
        cell.expirationDateLabel.text = dateFormatterOut.string(from: date!)

        let currDate = Date()
        if (expirationDate < currDate) {
            cell.backgroundColor = UIColor.red
        }
        
        cell.setFavorite(items[indexPath.row]["favorited"] as! Bool)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let query = PFQuery(className: "Grocery_Item")
            query.whereKey("objectId", equalTo: items[indexPath.row].objectId!)
            
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let objects = objects {
                    for object in objects {
                        object.deleteInBackground()
                    }
                }
            }
            
            items.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        groceriesTableView.deselectRow(at: indexPath, animated: true)
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
