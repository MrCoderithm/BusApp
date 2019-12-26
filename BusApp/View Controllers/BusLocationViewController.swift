//
//  BusLocationViewController.swift
//  BusApp
//
//  Created by Xcode User on 2019-12-07.
//  Copyright © 2019 Ali Muhammad. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import FirebaseDatabase
import CoreLocation

class BusLocationViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var theMapView: MKMapView!
    @IBOutlet var tfBusNumber: UITextField!
    
    var pointAnnotation:CustomPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var dbRef : DatabaseReference?
    var dbHandle : DatabaseHandle?
    
    var coordinates : CLLocation!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        //corpus christi high school burlington
        let initialLocation = CLLocation(latitude: 43.3977, longitude: -79.7845)
        
        centerMapOnLocation(location: initialLocation)
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = initialLocation.coordinate
        dropPin.title = "My School Landmark"
        self.theMapView.addAnnotation(dropPin)
        self.theMapView.selectAnnotation( dropPin, animated: true)

    }
    
    //Function to retrieve coordinates from the DB and Update the map
    func observeCoordinates(BusID: String) -> CLLocation{
        //Listener for value changes in the coordinates
        var clLocation : CLLocation!
        
        //enables listner and updates coordinate values when a change is made in the DB
        dbHandle = dbRef?.child("Busses").child(BusID).observe(.value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            let longitude = value?["longitude"] as? Double
            let latitude = value?["latitude"] as? Double
            
            //build CLLocation object for center map location
            clLocation = CLLocation(latitude: latitude!, longitude: longitude!)
        })
        
        var someLocation = CLLocation(latitude: 43.405854, longitude: -79.798082)
        
        return someLocation
    }
    
    //Async function to allow app usage while coordinates are being fetched from DB
    typealias CompletionHandler = (_ success:Bool) -> Void
    func doObserveCoordinates(busID: String,completionHandler: CompletionHandler) {
        
        coordinates = observeCoordinates(BusID: busID)
        
        let flag = true
        
        completionHandler(flag)
    }
    
    @IBAction func findLocationEventHandler(sender: UIButton){
        let busNumberInput = tfBusNumber.text
        
        doObserveCoordinates(busID: busNumberInput!) { (success) in
            
            if(success){
                centerMapOnBusLocation(location: coordinates)
            }else{
                print("Error getting location")
            }
        }
    }
    
    //Used to center map on the chosen school cite
    let regionRadius: CLLocationDistance = 3000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        theMapView.setRegion(coordinateRegion, animated: true)
    }
    
    //Centers the map on the new bus location to create a following the bus feature when coordinates are updated in DB
    func centerMapOnBusLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        theMapView.setRegion(coordinateRegion, animated: true)
        
        //Custom Pin annotation for tracking the bus
        let pin = CustomPointAnnotation(coor: location.coordinate)
        theMapView.addAnnotation(pin)
        
    }
    
    //Handles annotation types to display custom annotations
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }else{
            
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom pin")
            annotationView.image =  UIImage(named: "icons8-bus-100")
            annotationView.canShowCallout = true
            return annotationView
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
