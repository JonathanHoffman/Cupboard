//
//  RecipeDetailViewController.swift
//  Cupboard
//
//  Created by Jonathan Hoffman on 1/2/17.
//  Copyright © 2017 Jonathan Hoffman. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UITableViewController {
    var recipe: Recipe!
    
    @IBAction func openURL() {
        let recipeURL = URL(string: recipe.URL)
        
        let application = UIApplication.shared
        
        application.openURL(recipeURL!)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return recipe.ingredients.count

        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeInfo", for: indexPath)

        switch indexPath.section {
        case 0: // Name Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeInfo", for: indexPath)
            cell.textLabel!.text = recipe.name

        case 1: // URL Cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "LinkCell", for: indexPath)
            let button = cell.viewWithTag(1000) as! UIButton
            button.setTitle(recipe.URL, for: .normal)

        case 2: // Ingredients list
            cell.textLabel!.text = recipe.ingredients[indexPath.row]

        default:
            cell.textLabel!.text = recipe.name
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
