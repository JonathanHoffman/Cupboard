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

    enum Sections: Int {
        case title = 0
        case link = 1
        case ingredients = 2
    }
    
    @IBAction func openURL() {
        guard let recipeURL = URL(string: recipe.URL) else {
            print("Error: recipe.URL cannot be converted to type URL")
            print("recipe.URL: \(recipe.URL)")
            return
        }
        
        let application = UIApplication.shared
        
        application.openURL(recipeURL)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Sections(rawValue: section) else { return 0 }
        switch section {
        case .ingredients: return recipe.ingredients.count
        default: return 1
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        // section must be in Sections
        guard let section = Sections(rawValue: section) else { return nil }
        switch section {
        case .title: return "Title"
        case .link: return "Link"
        case .ingredients: return "Ingredients"
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
