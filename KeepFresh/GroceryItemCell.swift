//
//  ItemCell.swift
//  KeepFresh
//
//  Created by Albert Ai on 10/28/21.
//

import UIKit
import Parse
import CryptoKit

class GroceryItemCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var favorited: Bool = false
    var itemId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func favoriteItem(_ sender: Any) {
        if (!favorited) {
//            var query = PFQuery(className:"Grocery_Item")
//
//            query.getObjectInBackgroundWithId(itemId!) { (parseObject: PFObject?, error: NSError?) -> Void in
//                if error != nil {
//                    print(error)
//                } else if parseObject != nil {
//                    parseObject["favorited"] = true
//                    parseObject.saveInBackground()
//                }
//            }

            favorited = true
            setFavorite(favorited)
        }
        else {
//            var query = PFQuery(className:"Grocery_Item")
//
//            query.getObjectInBackgroundWithId(itemId!) { (parseObject: PFObject?, error: NSError?) -> Void in
//                if error != nil {
//                    print(error)
//                } else if parseObject != nil {
//                    parseObject["favorited"] = false
//                    parseObject.saveInBackground()
//                }
//            }

            favorited = false
            setFavorite(favorited)
        }
    }
    
    func setFavorite(_ isFavorited: Bool) {
        favorited = isFavorited
        if (favorited) {
            favButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        else {
            favButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    func setRed() {
        backgroundColor = UIColor.red
    }
}
