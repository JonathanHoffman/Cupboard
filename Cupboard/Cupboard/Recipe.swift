//
//  Recipe.swift
//  Cupboard
//
//  Created by Jonathan Hoffman on 1/2/17.
//  Copyright © 2017 Jonathan Hoffman. All rights reserved.
//

import Foundation

class Recipe {
    var name = String()
    var URL = String()
    var ingredients = [String]()
    var image = String()
    
    init?(fromRecipeDict dict: [String : Any]) {

        // Guard against cases where the values are not strings
        guard ((dict["title"] as? String) != nil), ((dict["href"] as? String) != nil),((dict["ingredients"] as? String) != nil), ((dict["thumbnail"] as? String) != nil) else {
            return nil
        }

        // Force casting should be protected by guard statement
        let title = dict["title"] as! String
        name = title.trimmingCharacters(in: .whitespacesAndNewlines)

        URL = dict["href"] as! String

        image = dict["thumbnail"] as! String

        let dictIngredients = dict["ingredients"] as! String
        ingredients = dictIngredients.components(separatedBy: ",")
        ingredients = ingredients.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
}
