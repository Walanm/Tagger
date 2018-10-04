//
//  CategoriesTableViewController.swift
//  Tagger
//
//  Created by Walan Marcel Teles Oliveira on 4/4/16.
//  Copyright © 2016 Walan Marcel Teles Oliveira. All rights reserved.
//

import UIKit
import CoreData

class CategoriesTableViewController: UITableViewController {
    
    //Attributes
    var tagCategories = [NSManagedObject]()
    
    
    //Event lifecycle methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tagCategories = DataManager.sharedInstance.getAllCategories()
        
        tableView.reloadData()
        
        
        // Code Chunk: Get the Path to the Working Documents Directory in Simulator
        
        
        //let documentDirectoryURL =  try! NSFileManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: true)
        
        //print(documentDirectoryURL)

    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tagCategories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
     
        // Create or grab a reuseable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
     
        let tagCategory = tagCategories[indexPath.row]
        
        cell.textLabel!.text = tagCategory.value(forKey: "title") as? String
     
        return cell
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "viewTags" {
            
            //Figure out which row was clicked
            if let row = tableView.indexPathForSelectedRow?.row {
                
                //Get the object that corresponds to that row
                let tappedTagCategory = tagCategories[row]
                
                //Figure out the destination view controller
                let tagsViewController = segue.destination as! TagsTableViewController
                
                //Hand the object to the destination VC
                tagsViewController.currentTagCategory = tappedTagCategory as? TagCategory

                
            }
            

        }
        
    }
    
    
    
    var deleteCategoryIndexPath: IndexPath? = nil
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCategoryIndexPath = indexPath
            let categoryToDelete = tagCategories[indexPath.row]
            confirmDelete(categoryToDelete)
        }
    }
    
    
    func confirmDelete(_ categoryDelete: NSManagedObject) {
        let categoryDeleteTitle = categoryDelete as? TagCategory
        let alert = UIAlertController(title: "Delete Location", message: "Are you sure you want to permanently delete \(categoryDeleteTitle!.title!)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteCategory)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteCategory)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func handleDeleteCategory(_ alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteCategoryIndexPath {
            tableView.beginUpdates()
            
            
            //Remove tag from core data
            DataManager.sharedInstance.removeCategory(tagCategories[indexPath.row] as! TagCategory)
            
            //Remove tag from the table
            tagCategories.remove(at: indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            deleteCategoryIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteCategory(_ alertAction: UIAlertAction!) {
        deleteCategoryIndexPath = nil
    }

    
    
    
    
}
