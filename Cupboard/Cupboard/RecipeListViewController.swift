//
//  RecipeListViewController.swift
//  Cupboard
//
//  Created by Jonathan Hoffman on 1/1/17.
//  Copyright © 2017 Jonathan Hoffman. All rights reserved.
//

import UIKit

class RecipeListViewController: UITableViewController {
    var recipes = ["test1", "test2", "Spaghetti"]
    var ingredients = ["noodles", "cheese"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let header = tableView.tableHeaderView
        // Capitalize the ingredients
        let CapitalizedIngredients = ingredients.map({ $0.capitalized })
        // Header should be UIView with a tagged UILabel
        if let ingredientsLabel = header?.viewWithTag(1001) as? UILabel {
            ingredientsLabel.text = CapitalizedIngredients.joined(separator: ", ")
        }
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
}

