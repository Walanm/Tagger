//
//  AddTagViewController.swift
//  Tagger
//
//  Created by Walan Marcel Teles Oliveira on 4/4/16.
//  Copyright © 2016 Walan Marcel Teles Oliveira. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddTagViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var currentTagCategory: TagCategory!
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation? = nil
    
    @IBOutlet var mapView: MKMapView!
    
    @IBOutlet weak var txtTagName: UITextField!
    @IBOutlet weak var txtLatitude: UILabel!
    @IBOutlet weak var txtLongitude: UILabel!
    @IBOutlet weak var txtCategory: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtCategory.text = currentTagCategory.title
        
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        locationManager!.startUpdatingLocation()

        self.mapView.showsUserLocation = true
        
        
    }
    
    
    
    //Location Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last as CLLocation!
        
        print("I received a location")
        print("\(currentLocation!.coordinate.latitude)")
        
        txtLatitude.text = "\(currentLocation!.coordinate.latitude)"
        txtLongitude.text = "\(currentLocation!.coordinate.longitude)"

        centerMapOnLocation(currentLocation!)
        
        //self.locationManager.stopUpdatingLocation()

        
    }
    
    
    func centerMapOnLocation(_ location: CLLocation) {
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }

    
    
    @IBAction func btnCancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func btnSave(_ sender: AnyObject) {
        
        let thisLocation: CLLocation = CLLocation(latitude: currentLocation!.coordinate.latitude, longitude: currentLocation!.coordinate.longitude)
        
        DataManager.sharedInstance.saveTag(currentTagCategory, tagName: txtTagName.text!, tagLocation: thisLocation)

        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
