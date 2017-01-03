//
//  EnterIngredientsViewController.swift
//  Cupboard
//
//  Created by Jonathan Hoffman on 1/1/17.
//  Copyright © 2017 Jonathan Hoffman. All rights reserved.
//

import UIKit

protocol EnterIngredientsViewControllerDelegate: class {
    func enterIngredientsViewControllerDidCancel(_ controller: EnterIngredientsViewController)
    func enterIngredientsViewController(_ controller: EnterIngredientsViewController, didFinishEntering ingredients: [String])
}

class EnterIngredientsViewController: UITableViewController, UITextFieldDelegate {
    var ingredients = [String]()
    
    weak var delegate: RecipeListViewController?

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        // First section for entering ingredients, second section for listing them
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return ingredients.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientEntry", for: indexPath)

            return cell

        } else {
            let cell = makeIngredientCell(for: tableView)
            cell.textLabel?.text = ingredients[indexPath.row]
            
            return cell
        }
    }
    
    // Tapping Done on the ingredient entry keyboard goes here
    @IBAction func addIngredientFromTextField() {

        // IndexPath of the entry cell
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath)
        let textField = cell?.viewWithTag(1000) as! UITextField
        
        // Update both the data model and the tableView
        if let ingredient = textField.text {
            let indexPath = IndexPath(row: ingredients.count, section: 1)
            ingredients.append(ingredient)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            textField.text = ""
        }
    }
    
    @IBAction func cancel() {
        delegate?.enterIngredientsViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        delegate?.enterIngredientsViewController(self, didFinishEntering: ingredients)
    }
    
    // Return a default reusable cell for the ingredients list
    func makeIngredientCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "IngredientCell"

        // First, check to see if we have a cell lying around that we can re-use.
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        // If we are fresh out of cells, lets whip up a new one
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        // Do not allow editing of the ingredient entry cell
        if indexPath.section == 0 {
            return false
        }

        return true
    }

    // Support for deleting ingredients
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredients.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
