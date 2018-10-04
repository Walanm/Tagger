//
//  TagsMapViewController.swift
//  Tagger
//
//  Created by Walan Marcel Teles Oliveira on 5/2/16.
//  Copyright © 2016 Walan Marcel Teles Oliveira. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TagsMapViewController: UIViewController, MKMapViewDelegate {
    
    var currentTagCategory: TagCategory!
    var tags = [NSManagedObject]()
    var tagAnnotations = [MKPointAnnotation]()
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tags = DataManager.sharedInstance.getAllTags(currentTagCategory)
        
        navigationItem.title = currentTagCategory.title
        
        mapView.delegate = self
        
        self.tagAnnotations = tagToAnnotation(tags)
        
        self.mapView.layoutMargins = UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100)
        self.mapView.showAnnotations(tagAnnotations, animated: true )

        
    }
    
    //Return an array of annotations from an array of NSManagedObject
    func tagToAnnotation (_ tagCollection: [NSManagedObject]) -> [MKPointAnnotation] {
        
        var annotationCollection = [MKPointAnnotation]()
        
        for i in 0...(tags.count-1) {
            
            let tag = tags[i] as! Tag
            
            print(tag.title!)
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = CLLocationCoordinate2D(latitude: tag.latitude! as Double, longitude: tag.longitude! as Double)

            annotation.title = tag.title
            
            annotationCollection.append(annotation)
            
        }
        
        return annotationCollection
        
    }
    
    
    
}
