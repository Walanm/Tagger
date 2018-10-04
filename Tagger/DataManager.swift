//
//  DataManager.swift
//  Tagger
//
//  Created by Walan Marcel Teles Oliveira on 4/4/16.
//  Copyright © 2016 Walan Marcel Teles Oliveira. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class DataManager: NSObject {
    
    static let sharedInstance = DataManager()
    
    //Get all categories
    func getAllCategories() -> [NSManagedObject] {
        
        //Reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //Reference to the Managed Object Context
        let managedContext = appDelegate.managedObjectContext
        
        //Create a fetch request for a specific entiy
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TagCategory")
        
        //Create a collection of NSManagedObjects (Tag Categories)
        var tagCategories = [NSManagedObject]()
        
        //Execute the fetch request
        do {
            let results = try managedContext.fetch(fetchRequest)
            tagCategories = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch tag categories \(error), \(error.userInfo)")
        }
        
        
        //Return the collection of tag categories
        return tagCategories
        
    }
    
    //Get all of the tags in a category
    
    //Save a new category
    func saveTagCategory(_ tagCategoryName: String) {
    
        //Reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
        //Reference to the Managed Object Context
        let managedContext = appDelegate.managedObjectContext
    
        //Describe the entity (class/db table) we wish to work with
        let entity = NSEntityDescription.entity(forEntityName: "TagCategory", in: managedContext)
    
        //Create an empty instance of the entity and add it to the M.O.C.
        let category = NSManagedObject(entity: entity!, insertInto: managedContext)
    
        //Add values to the instance's attributes
        category.setValue(tagCategoryName, forKey: "title")
    
        //Send the instance to the database vie the M.O.C. ("deliver the object")
        do {
            try managedContext.save()
            
            print("saveTagCategory deu certo")
            
        }
        catch let error as NSError {
            print("Could not save Tag Category \(error), \(error.userInfo)")
        }
        
    }
    
    
    //Save a new tag in a category
    func saveTag(_ parentCategory: TagCategory, tagName: String, tagLocation: CLLocation) {
        
        //Reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //Reference to the Managed Object Context
        let managedContext = appDelegate.managedObjectContext
        
        //Describe the entity (class/db table) we wish to work with
        let entity = NSEntityDescription.entity(forEntityName: "Tag", in: managedContext)
        
        //Create an empty instance of the entity and add it to the M.O.C.
        let newTag = NSManagedObject(entity: entity!, insertInto: managedContext) as! Tag
        
        //Add values to the instance's attributes
        newTag.category = parentCategory
        newTag.title = tagName as String
        newTag.latitude = tagLocation.coordinate.latitude as NSNumber
        newTag.longitude = tagLocation.coordinate.longitude as NSNumber
        
        //Send the instance to the database vie the M.O.C. ("deliver the object")
        do {
            try managedContext.save()
            
            print("saveTag deu certo")
            
        }
        catch let error as NSError {
            print("Could not save Tag \(error), \(error.userInfo)")
        }
        
    }

    
    
    func getAllTags(_ currentCategory: TagCategory) -> [NSManagedObject] {
        
        //Reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //Reference to the Managed Object Context
        let managedContext = appDelegate.managedObjectContext
        
        //Create a fetch request for a specific entiy
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        
        //Create a collection of NSManagedObjects (Tag Categories)
        var tags = [NSManagedObject]()
        
        //Create NSPredicate & attach it to fetchRequest
        let predicate = NSPredicate(format: "category == %@", currentCategory)
        fetchRequest.predicate = predicate
        
        //Execute the fetch request
        do {
            let results = try managedContext.fetch(fetchRequest)
            tags = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch tag categories \(error), \(error.userInfo)")
        }
        
        
        //Return the collection of tag categories
        return tags
        
    }
    
    func removeRecord(_ recordToRemove: NSManagedObject) {
        
        
        //Reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //Reference to the Managed Object Context
        let managedContext = appDelegate.managedObjectContext
        
        //Delete Element
        managedContext.delete(recordToRemove)
        
        //Save changes
        do {
            try managedContext.save()
            print("Successfully deleted the element!")
        } catch let error as NSError {
            print("Could not delete tag: \(error), \(error.userInfo)")
        }
        
    }
    
    func removeCategory(_ categoryToRemove: TagCategory) {
        
        //Reference to the app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //Reference to the Managed Object Context
        let managedContext = appDelegate.managedObjectContext
        
        //Create a fetch request for a specific entiy
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
        
        //Create NSPredicate & attach it to fetchRequest
        let predicate = NSPredicate(format: "category == %@", categoryToRemove)
        fetchRequest.predicate = predicate
        
        //Create a delete request to delete the tags
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        //Execute the fetch request
        do {
            try managedContext.execute(deleteRequest)
            print("Successfully deleted the tags!")
        } catch let error as NSError {
            print("Could not delete category: \(error), \(error.userInfo)")
        }
        
        //Delete the category
        DataManager.sharedInstance.removeRecord(categoryToRemove)
        
        
    }
    
    
}
