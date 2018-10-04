//
//  RouteMapViewController.swift
//  Tagger
//
//  Created by Walan Marcel Teles Oliveira on 4/25/16.
//  Copyright © 2016 Walan Marcel Teles Oliveira. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RouteMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var currentTag: Tag!
    var currentLocation: CLLocation? = nil
    var locationManager: CLLocationManager!


    @IBOutlet weak var mapView: MKMapView!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = currentTag.title
        
        mapView.delegate = self
        
        // Get both current and tag location
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.requestWhenInUseAuthorization()
        locationManager!.startUpdatingLocation()
        
        
    }
    
    
    //MapView Delegate Methods
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        
        mapView.selectAnnotation(mapView.annotations.last!, animated: true)
        
    }
    
    
    //Location Delegate Method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last as CLLocation!
        
        print("I received current location")
        print("\(currentLocation!.coordinate.latitude)")
        
        self.locationManager.stopUpdatingLocation()
        
        routeFinder(currentLocation, tagLocation: currentTag)
        
        
    }
    
    
    
    func routeFinder(_ userLocation: CLLocation?, tagLocation: Tag!) {
        
        //Set the latitude and longtitude of the locations
        let sourceLocation = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        
        let destinationLocation = CLLocationCoordinate2D(latitude: currentTag.latitude! as Double, longitude: currentTag.longitude! as Double)
        
        //Create placemark objects containing the locations' coordinates
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        //Create MKMapitems to be used for routing
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        //Show user location
        mapView.showsUserLocation = true
        
        //Add annotation
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = currentTag.title
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        //Display annotation on the map
        self.mapView.showAnnotations([destinationAnnotation], animated: true )

        //Use MKDirectionsRequest class to compute the route
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        //Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        //Draw the route and set region so both locations are visible
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0), animated: true)
            
        }
        
        
        
    }

    

}
