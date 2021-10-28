//
//  ItemCell.swift
//  KeepFresh
//
//  Created by Albert Ai on 10/28/21.
//

import UIKit

class GroceryItemCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var expirationDateLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    var favorited: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func favoriteItem(_ sender: Any) {
        if (!favorited) {
//            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: { self.setFavorite(true) }, failure: {(error) in
//                print("Favorite did not succeed: \(error)")
//            })
            favorited = true
            setFavorite(favorited)
        }
        else {
//            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: { self.setFavorite(false) }, failure: {(error) in
//                print("Unfavorite did not succeed: \(error)")
//            })
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
}
