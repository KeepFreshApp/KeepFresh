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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groceriesTableView.delegate = self
        groceriesTableView.dataSource = self
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let query = PFQuery(className: "Grocery_Item")
        query.whereKey("owner", equalTo: PFUser.current()!.username!)
        
        let defaults = UserDefaults.standard

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
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "darkModeState") == true {
            cell.backgroundColor = UIColor.black
        }
        else{
            cell.backgroundColor = UIColor.white
        }
        let item = items[indexPath.row]
        
        cell.itemNameLabel.text = item["itemName"] as? String
        cell.categoryLabel.text = item["category"] as? String
        cell.itemId = item.objectId
        
        let expirationDate = items[indexPath.row]["expiryDate"] as! Date
        let creationDate = items[indexPath.row].createdAt!
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "M/d/yyyy, h:mm a"
        let dateFormatterOut = DateFormatter()
        dateFormatterOut.dateFormat = "MMM d, yyyy"
        
        var date: Date?
        if defaults.integer(forKey: "sortBy") == 0 {
            date = dateFormatterGet.date(from: creationDate.formatted())
        }
        else {
            date = dateFormatterGet.date(from: expirationDate.formatted())
        }
        cell.expirationDateLabel.text = dateFormatterOut.string(from: date!)

        let currDate = Date()
        if (expirationDate < currDate) {
            cell.backgroundColor = UIColor.red
        } else {
            let expiryrange = defaults.integer(forKey: "NotifyDays")
            var dateComponent = DateComponents()
            dateComponent.day = expiryrange
        
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: currDate)
            if (expirationDate < futureDate!) {
                cell.backgroundColor = UIColor.orange
            }
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
