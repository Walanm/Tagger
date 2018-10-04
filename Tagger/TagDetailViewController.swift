//
//  TagDetailViewController.swift
//  Tagger
//
//  Created by Walan Marcel Teles Oliveira on 4/17/16.
//  Copyright © 2016 Walan Marcel Teles Oliveira. All rights reserved.
//

import UIKit
import Social

class TagDetailViewController: UIViewController {
    
    var currentTag: Tag!
    
    @IBOutlet weak var txtTagLabel: UILabel!
    @IBOutlet weak var txtLatitude: UILabel!
    @IBOutlet weak var txtLongitude: UILabel!
    
    
    @IBAction func post(_ sender: AnyObject) {
        post(toService: SLServiceTypeFacebook)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        txtTagLabel.text = currentTag.title
        
        txtLatitude.text = "\(currentTag.latitude!)"
        txtLongitude.text = "\(currentTag.longitude!)"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Check the segue name
        
        if segue.identifier == "routeTag" {
            
            let routeMapViewController = segue.destination as! RouteMapViewController
            
            routeMapViewController.currentTag = currentTag
            
            
        }
    }
    
    //Post on Facebook
    func post(toService service: String) {
        if(SLComposeViewController.isAvailable(forServiceType: service)) {
            let socialController = SLComposeViewController(forServiceType: service)
            socialController?.setInitialText("Checked in to \(currentTag.title!) via Tagger! \n\n To all true stalkers out there:\n Lat: \(currentTag.latitude!) \n Long: \(currentTag.longitude!)"  )
            self.present(socialController!, animated: true, completion: nil)
        }
    }
    
}
