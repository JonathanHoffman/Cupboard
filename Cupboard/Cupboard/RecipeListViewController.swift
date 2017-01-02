//
//  RecipeListViewController.swift
//  Cupboard
//
//  Created by Jonathan Hoffman on 1/1/17.
//  Copyright © 2017 Jonathan Hoffman. All rights reserved.
//

import UIKit

class RecipeListViewController: UITableViewController {
    var recipes = ["Lasagna", "Mac and Cheese", "Spaghetti"]
    var ingredients = ["noodles", "cheese"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeItem", for: indexPath)
        
        let recipe = recipes[indexPath.row]
        
        let label = cell.viewWithTag(1000) as! UILabel
        
        label.text = recipe
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            // Capitalize the ingredients
            let CapitalizedIngredients = ingredients.map({ $0.capitalized })
            // Header should be UIView with a tagged UILabel
            return CapitalizedIngredients.joined(separator: ", ")
        } else {
            return nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EnterIngredients" {
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! EnterIngredientsTableViewController
            controller.ingredients = ingredients
        }
    }
}

