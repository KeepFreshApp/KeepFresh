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
        // query.includeKeys(["owner", "objectId"])
        query.whereKey("owner", equalTo: PFUser.current()!.username!)
        query.order(byAscending: "expiryDate")
        query.findObjectsInBackground { (items, error) in
            if (items != nil) {
                self.items = items!
                self.groceriesTableView.reloadData()
            }
        }
      
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "darkModeState") == true {
            overrideUserInterfaceStyle = .dark
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        } else {
            overrideUserInterfaceStyle = .light
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
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
        let item = items[indexPath.row]
        
        cell.itemNameLabel.text = item["itemName"] as? String
        cell.categoryLabel.text = item["category"] as? String
        
        let expirationDate = items[indexPath.row]["expiryDate"] as! Date
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "M/d/yyyy, h:mm a"
        let dateFormatterOut = DateFormatter()
        dateFormatterOut.dateFormat = "MMM d, yyyy"
        let date: Date? = dateFormatterGet.date(from: expirationDate.formatted())
        cell.expirationDateLabel.text = dateFormatterOut.string(from: date!)

        let currDate = Date()
        if (expirationDate < currDate) {
            cell.setRed()
        }
        
        cell.setFavorite(items[indexPath.row]["favorited"] as! Bool)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
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
