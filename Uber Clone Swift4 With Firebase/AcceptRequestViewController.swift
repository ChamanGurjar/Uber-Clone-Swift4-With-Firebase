//
//  AcceptRequestViewController.swift
//  Uber Clone Swift4 With Firebase
//
//  Created by Chaman Gurjar on 18/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase

class AcceptRequestViewController: UIViewController {
    private static let RIDER_TABLE_NAME = "RideRequest"
    
    @IBOutlet private weak var mapView: MKMapView!
    
    var requestLocation = CLLocationCoordinate2D()
    var driverLocation = CLLocationCoordinate2D()
    var requesterEmail = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showRiderLocationOnMapWithAnnotation()
    }
    
    private func showRiderLocationOnMapWithAnnotation() {
        let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = requestLocation
        annotation.title = requesterEmail
        mapView.addAnnotation(annotation)
    }
    
    //MARK: - Open map with Rider Location
    private func openMapWithRiderLocation() {
        let location = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, err) in
            if let placeMarks = placemarks {
                if placeMarks.count > 0 {
                    let placeMark = MKPlacemark(placemark: placeMarks[0])
                    let mapItem = MKMapItem(placemark: placeMark)
                    mapItem.name = self.requesterEmail
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                    mapItem.openInMaps(launchOptions: launchOptions)
                }
            }
        }
    }
    
    @IBAction func acceptRideRequest(_ sender: UIButton) {
        let request = Database.database().reference().child(AcceptRequestViewController.RIDER_TABLE_NAME)
        
        request.queryOrdered(byChild: "email").queryEqual(toValue: requesterEmail).observe(.childAdded) { (snapshot) in
            snapshot.ref.updateChildValues(["driverLat": self.driverLocation.latitude,  "driverLong": self.driverLocation.longitude])
            request.removeAllObservers()
        }
        
        openMapWithRiderLocation()
    }
    
    
}
