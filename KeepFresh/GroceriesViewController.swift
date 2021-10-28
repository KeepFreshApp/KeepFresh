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
    var numberOfItems = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()

        groceriesTableView.delegate = self
        groceriesTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        let query = PFQuery(className: "Grocery_Item")
        query.includeKeys(["owner"])
        query.limit = numberOfItems
        query.findObjectsInBackground { (items, error) in
            if (items != nil) {
                self.items = items!
                self.groceriesTableView.reloadData()
            }
        }
    }
    
    // Item loading stuff
    
    
    // TableView stuff
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groceriesTableView.dequeueReusableCell(withIdentifier: "GroceryItemCell", for: indexPath) as! GroceryItemCell
        
        cell.itemNameLabel.text = items[indexPath.row]["itemName"] as? String
        cell.categoryLabel.text = items[indexPath.row]["category"] as? String
        
        let expirationDate = items[indexPath.row]["expiryDate"] as! Date
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "M/d/yyyy, h:mm a"
        let dateFormatterOut = DateFormatter()
        dateFormatterOut.dateFormat = "MMM d, yyyy"

        let date: Date? = dateFormatterGet.date(from: expirationDate.formatted())
        cell.expirationDateLabel.text = dateFormatterOut.string(from: date!)
        
        cell.setFavorite(items[indexPath.row]["favorited"] as! Bool)
        
        return cell
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
