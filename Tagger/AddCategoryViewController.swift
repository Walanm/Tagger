//
//  AddCategoryViewController.swift
//  Tagger
//
//  Created by Walan Marcel Teles Oliveira on 4/4/16.
//  Copyright © 2016 Walan Marcel Teles Oliveira. All rights reserved.
//

import UIKit

class AddCategoryViewController: UIViewController {
    
    
    //Outlets
    @IBOutlet weak var txtCategoryName: UITextField!
    
    
    //Actions
    @IBAction func btnCancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)

    }
    

    @IBAction func btnSave(_ sender: AnyObject) {
        
        DataManager.sharedInstance.saveTagCategory(txtCategoryName.text!)
        
        self.dismiss(animated: true, completion: nil)

    }

    
    
    
    
}

