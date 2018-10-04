//
//  TagsTableViewController.swift
//  Tagger
//
//  Created by Walan Marcel Teles Oliveira on 4/4/16.
//  Copyright © 2016 Walan Marcel Teles Oliveira. All rights reserved.
//

import UIKit
import CoreData

class TagsTableViewController: UITableViewController {
    
    var currentTagCategory: TagCategory!
    
    var tags = [NSManagedObject]()
    
    
    //Event lifecycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tags = DataManager.sharedInstance.getAllTags(currentTagCategory)
        
        tableView.reloadData()
        
        print(currentTagCategory.title!)
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // Create or grab a reuseable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let tag = tags[indexPath.row]
        
        cell.textLabel!.text = tag.value(forKey: "title") as? String
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "addTag" {
            
            //Figure out the destination view controller
            let navCtrller = segue.destination as! UINavigationController
            
            let addTagViewController = navCtrller.topViewController as! AddTagViewController
            
            //Hand the object to the destination VC
            addTagViewController.currentTagCategory = currentTagCategory! as TagCategory
            
        }
        
        if segue.identifier == "detailTag" {
        
            if let row = tableView.indexPathForSelectedRow?.row {
            
                let tappedTag = tags[row]
                let tagDetailViewController = segue.destination as! TagDetailViewController
                tagDetailViewController.currentTag = tappedTag as? Tag
            
            }
        }
        
        if segue.identifier == "mapTags" {
            
            //let navCtrller = segue.destinationViewController as! UINavigationController
            
            let tagsMapViewController = segue.destination as! TagsMapViewController
            
            tagsMapViewController.currentTagCategory = currentTagCategory! as TagCategory
            
        }
        
    }
    
    
    
    var deleteTagIndexPath: IndexPath? = nil
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTagIndexPath = indexPath
            let tagToDelete = tags[indexPath.row]
            confirmDelete(tagToDelete)
        }
    }
    
    
    func confirmDelete(_ tagDelete: NSManagedObject) {
        let tagDeleteTitle = tagDelete as? Tag
        let alert = UIAlertController(title: "Delete Location", message: "Are you sure you want to permanently delete \(tagDeleteTitle!.title!)?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: handleDeleteTag)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeleteTag)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        // Support display in iPad
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.size.width / 2.0, y: self.view.bounds.size.height / 2.0, width: 1.0, height: 1.0)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func handleDeleteTag(_ alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteTagIndexPath {
            tableView.beginUpdates()
            
    
            //Remove tag from core data
            DataManager.sharedInstance.removeRecord(tags[indexPath.row])
            
            //Remove tag from the table
            tags.remove(at: indexPath.row)
            
            // Note that indexPath is wrapped in an array:  [indexPath]
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            deleteTagIndexPath = nil
            
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteTag(_ alertAction: UIAlertAction!) {
        deleteTagIndexPath = nil
    }
    
    
}
