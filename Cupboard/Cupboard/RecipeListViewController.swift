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
    // Used to indicate that the table view data is loading
    var isLoading = true
    // View controller should be aware of the session data task. Used to prevent multiple searches from occuring simultaneously 
    var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchIngredients()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

// MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // If we don't have any data right now, use 1 row to display a cell.
        if isLoading || recipes.count == 0 || ingredients.count == 0{
            return 1
        } else {
            return recipes.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // if we are loading data, show this instead
        if isLoading {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingCell", for: indexPath)
            return cell
        } else if ingredients.count == 0 {
            // Let the user know to select some ingredients
            let cell = tableView.dequeueReusableCell(withIdentifier: "ErrorCell", for: indexPath)
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = "Search for some ingredients first!"
            
            return cell
        } else if recipes.count == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ErrorCell", for: indexPath)
            let label = cell.viewWithTag(1000) as! UILabel
            label.text = "We couldn't find any recipes with those ingredients."
            
            return cell
        } else {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeItem", for: indexPath)
            
            let recipe = recipes[indexPath.row]
            
            let label = cell.viewWithTag(1000) as! UILabel
            
            label.text = recipe
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Header is not displayed when loading
        if section == 0, !isLoading {
            // Capitalize the ingredients
            let capitalizedIngredients = ingredients.map({ $0.capitalized })
            // Header should be UIView with a tagged UILabel
            return capitalizedIngredients.joined(separator: ", ")
        } else {
            return nil
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EnterIngredients" {
            // get the enter ingredient controller
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! EnterIngredientsViewController
            // initialize that controller
            controller.delegate = self
            controller.ingredients = ingredients
        }
    }
    
    func searchIngredients() {
        //prepare the URL session and request
        let session = URLSession.shared
        let apiString = makeAPIString(forIngredients: ingredients)
        let apiURL: URL = URL(string: apiString)! as URL
        let request = NSMutableURLRequest(url: apiURL)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        //Indicate that data is loading
        self.dataTask?.cancel()
        isLoading = true
        tableView.reloadData()
        // start the data task
        let dataTask = session.dataTask(with: request as URLRequest) {data, response, error in
            
            if let error = error as? NSError, error.code == -999 {
                return
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                
                if let data = data {
                    let json = self.parse(jsonFrom: data)
                    print(json!)
                    self.recipes = self.parse(recipesFrom: json)
                    // add an async dispatch to display the new data once this task is done
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.tableView.reloadData()
                    }
                    // exit the callback
                    return
                    
                } else {
                    print("data error")
                }
            }
            // Queue up a response if this dataTask fails
            DispatchQueue.main.async {
                self.isLoading = false
                self.tableView.reloadData()
                print("Network error")
            }
        }
        print("resuming tasks")
        dataTask.resume()
    }
    
    func makeAPIString(forIngredients ingredients: [String]) -> String {
        var stringAPI = "http://recipepuppy.com/api/"
        stringAPI.append("?i=") // ingredients list token
        stringAPI.append(ingredients.joined(separator: ","))
        stringAPI = stringAPI.replacingOccurrences(of: " ", with: "%20")
        return stringAPI
    }
    
    func parse(jsonFrom data: Data) -> [String: Any]? {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print("JSON Error: \(error)")
            return nil
        }
    }
    
    func parse(recipesFrom json: [String : Any]?) -> [String] {
        // The JSON object will have a results dict full of recipes.
        guard let recipesArray = json?["results"] as? [Any] else {
            print("Expected 'results' array")
            return []
        }
        // Store new recipes in here.
        var recipeNames = [String]()
        // Process each recipe in the array
        for recipeDict in recipesArray {
            // process valid dicts only
            if let recipeDict = recipeDict as? [String: Any] {
                if var recipeName = recipeDict["title"] as? String {
                    recipeName = recipeName.replacingOccurrences(of: "\n", with: "")
                    recipeNames.append(recipeName)
                } else {
                    print("Recipe title not valid")
                }
            }
        }
        return recipeNames
    }
}

// MARK: - EnterIngredientViewControllerDelegate

extension RecipeListViewController: EnterIngredientsViewControllerDelegate {
    func enterIngredientsViewControllerDidCancel(_ controller: EnterIngredientsViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func enterIngredientsViewController(_ controller: EnterIngredientsViewController, didFinishEntering ingredients: [String]) {
        // Update the ingredients list.
        // This list will be short and in most cases totally different from the previous time.
        // Therefore, I've opted to have this delegate method to replace it each time.
        self.ingredients = ingredients
        // Search for new ingredients
        searchIngredients()
        // Update the table view.
        // Again, the data should be manageable to do this in bulk.
        tableView.reloadData()
        // Dismiss the modal EnterIngredientsView
        dismiss(animated: true, completion: nil)
    }
}
