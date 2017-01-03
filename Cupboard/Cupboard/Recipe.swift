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
    
    init(fromRecipeDict dict: [String : Any]) {
        let title = dict["title"] as! String
        name = title.replacingOccurrences(of: "\n", with: "")

        image = dict["thumbnail"] as! String

        URL = dict["href"] as! String
        
        let dictIngredients = dict["ingredients"] as!  String
        ingredients = dictIngredients.components(separatedBy: ", ")
    }
}
