# KeepFresh

Albert Ai
Aditi Gandhi
Matthew Peng
Dhwanil Mehta

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
A tracker-inspired app that allows people to be updated of the expiration of their produce and pantry items. It provides assistance in optimitizing food use with their available food items.

### App Evaluation
[Evaluation of your app across the following attributes]
- **Category:**
    - Health, Productivity
- **Mobile:**
    - We want our app to be easy to use and always accessible. A mobile app best fits our goals as our target user will probably have access to a phone when putting away their groceries. In addition, opening an app takes less time than opening a web browser and then typing in an url.
- **Story:**
    - The purpose of this app is to provide a framework of keeping track of all grocery items. Whether it be to remind users of grocery items they have forgotten about, allow users to optimize food usage before it spoils, or provide an accessible forum to meal planning, this app will be a versatile modem to do it all.
- **Market:** 
    - Since everyone buys groceries, we expect that our app can potentially have a large userbase.
- **Habit:**
    -  This app is probably not habit-forming. We intend for the user to open this app every time they finish buying groceries, which may vary based on the user.
- **Scope:**
    - The scope for this app is pretty well formed, as we are targeting people that have food in their house who want to keep better track of the expiry dates. Based on our discussion our group is confident that we can effectively implement all our required user stories by the end of the course.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

[X] User can create an account, sign up and login
[X] User remains logged in unless they log out
[X] User can log out


![ezgif com-gif-maker](https://user-images.githubusercontent.com/45218230/139597296-dcb968a2-16eb-468f-8da7-110bd31ac49c.gif)



[X] User can add food item entries

![ezgif com-gif-maker (1)](https://user-images.githubusercontent.com/45218230/139597891-2fc8188e-89f2-4734-ac99-fac75548fed0.gif)



[] Foods expiring within a few days are colored in red
[] User can favorite items 
[] Favorited items can be visible in a separate list
[] Sort items by expiration date
[X] Implement a settings menu

**Optional Nice-to-have Stories**

* Sort items by purchase date
* User can filter food by food type/category
* User will be notified when foods are expiring within a couple of days

### 2. Screen Archetypes

* Item Add Screen
   * User can add food item entries
   * User can filter food by food type/category
* Items list
   * Foods expiring within a few days are colored in red
   * Sort items by expiration date
   * User can favorite items
   * Sort items by purchase date
   * User can filter food by food type/category
* Favorited items list
    * Favorited items can be visible in a separate list
* Settings Menu
    * Implement a settings menu
    * User will be notified when foods are expiring within a couple of days

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Items list
* Favorited items list

**Flow Navigation** (Screen to Screen)

* Item Add Screen
   * => Items List (after all item information has been entered)
* Items List
   * => Item Add Page
   * => Settings screen
* Favorited Items List
   * => None 
* Settings Menu
   * => Items List (after user finishes editing settings) 

## Wireframes
![](https://i.imgur.com/FgcyC0u.png)

### [BONUS] Digital Wireframes & Mockups

### [BONUS] Interactive Prototype

## Schema
### Models
#### foodItem

   | Property      | Type            | Description                  |
   | ------------- | --------        | ------------                 |
   | itemId        | String          | unique id for the item       |
   | itemName      | String          | name of food item            |
   | owner         | Pointer to User | unique id for user           |
   | category      | String          | item category by user        |
   | expiryDate    | DateTime        | date when item expires       |
   | favorited     | Boolean         | item's favorited status      |
   | purchaseDate  | DateTime        | date when item was purchased |
   
### Networking
- Item Add Screen
    - (POST) Add an item and its designated information to the items list
    ```swift
    let item = PFObject(className: "Items")
    item["itemId"] = itemId
    item["itemName"] = itemName
    item["owner"] = PFUser.current()!
    item["category"] = category
    item["expiryDate"] = expiryDate
    item["favorited"] = false
    item["purchaseDate"] = purchaseDate
    
    post.saveInBackground { (success, error) in
        if success {
            self.dismiss(animated: true, completion: nil)
        } else {
            print("Error")
        }
    }
    ```
- Items List Screen 
    - (GET) Retrieve list of items and their properties
    ```swift
    var posts = [PFObject]()
    let query = PFQuery(className:"Items")
    query.whereKey("owner", equalTo: PFUser.current())
    query.findObjectsInBackground { (posts, error) in
        if (posts != nil) {
            self.posts = posts!
            self.tableView.reloadData()
        }
    }
    ```
    - (POST/PUT) Update Favorited status of items
    ```swift
    var query = PFQuery(className:"Items")
    query.getObjectInBackgroundWithId(itemId) { (item: PFObject?, error: NSError?) -> Void in
        if error != nil {
            print(error)
        } else if let item = item {
            item["favorited"] = !item["favorited"]
            item.saveInBackground()
        }
    }
    ```
    - (DELETE) Remove item from the list
    ```swift
    let query = PFQuery(className: "Items")
    query.whereKey("itemId", equalTo: itemId)
    query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
        for item in items {
            item.deleteEventually()
        }
    }
    ```
- Favorited Items List Screen
    - (GET) Retrieve list of favorited items and their properties
    ```swift
    var posts = [PFObject]()
    let query = PFQuery(className:"Items")
    query.whereKey("owner", equalTo:PFUser.current()).whereKey("favorited", equalTo: True)
    query.findObjectsInBackground { (posts, error: Error?) in
    if error != nil {
        print(error.localizedDescription)
    } 
    else{
        self.posts = posts!
        self.tableView.reloadData()
    }
    ```
    - (POST/PUT) Update Favorited status of items
    ```swift
    var query = PFQuery(className:"Items")
    query.getObjectInBackgroundWithId(itemId) { (item: PFObject?, error: NSError?) -> Void in
        if error != nil {
            print(error)
        } else if let item = item {
            item["favorited"] = !item["favorited"]
            item.saveInBackground()
        }
    }
    ```
