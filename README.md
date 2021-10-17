# KeepFresh

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
    - We want our app to be easy to use and always accessible. A mobile app best fits our goals as our target user will probably have access to a phone when putting away their groceries.
- **Story:**
    - The purpose of this app is to provide a framework of keeping track of all grocery items. Whether it be to remind users of grocery items they have forgotten about, allow users to optimize food usage before it spoils, or provide an accessible forum to meal planning, this app will be a versatile modem to do it all.
- **Market:** 
    - Since everyone buys groceries, we expect that our app can potentially have a large userbase.
- **Habit:**
    -  This app is probably not habit-forming. We intend for the user to open this app every time they finish buying groceries, which could be on a weekly basis.
- **Scope:**
    - People that have food in their house who want to keep better track of the expiry dates

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can add food item entries
* Foods expiring within a few days are colored in red
* User can favorite items 
* Favorited items can be visible in a separate list
* Sort items by expiration date
* Implement a settings menu

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
[This section will be completed in Unit 9]
### Models
[Add table of models]
### Networking
- [Add list of network requests by screen ]
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]
