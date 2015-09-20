//
//  DayMealsViewController.swift
//  Spatula
//
//  Created by Hana Kim on 9/13/15.
//  Copyright (c) 2015 Bobby Ren. All rights reserved.
//

import UIKit

class DayMealsViewController: UITableViewController {

    var generatedRowIndices: [Int] = [Int]()
    let totalMeals: Int = 4
    var breakfastRecipe: Recipe!
    var lunchRecipe: Recipe!
    var dinnerRecipe: Recipe!
    var snackRecipe: Recipe!
    
    var recipes: [Recipe] = [Recipe]()
    var selectedMeal: Int!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.randomizeRowIndices()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: "close")
    }

    // MARK: Datasource
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    // one for breakfast, lunch, dinner, snack
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return totalMeals
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MealCell", forIndexPath: indexPath)

        let imageView: UIImageView = cell.contentView.viewWithTag(1) as! UIImageView
        let labelName: UILabel = cell.viewWithTag(2) as! UILabel
        let labelCount: UILabel = cell.viewWithTag(3) as! UILabel
        
        let row = indexPath.row
        let index = self.generatedRowIndices[row] as Int
        let recipe: Recipe = RecipeDataSource.recipeWithId(index)!
        imageView.image = recipe.image
        labelName.text = recipe.name
        labelCount.text = "\(recipe.calories) kCal"
        
        recipes.append(recipe)
        
        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140
    }

    // MARK: Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedMeal = indexPath.row
        performSegueWithIdentifier("goToMealDetails", sender: self)
    }
    
    func close() {
        self.navigationController!.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller = segue.destinationViewController as! MealViewController
        controller.recipe = recipes[selectedMeal]
    }
    
    func randomizeRowIndices() {
        self.generatedRowIndices.removeAll(keepCapacity: true)
        while self.generatedRowIndices.count < self.totalMeals {
            let index = Int(arc4random_uniform(UInt32(RecipeDataSource.recipeCount())))
            if self.generatedRowIndices.indexOf(index) == nil {
                self.generatedRowIndices.append(index)
            }
        }
        
        print("indices: ")
        for index: Int in self.generatedRowIndices {
            print("\(index)")
        }
        print("\n")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
