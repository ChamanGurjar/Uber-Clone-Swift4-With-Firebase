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
    
    @IBAction func acceptRideRequest(_ sender: UIButton) {
        
    }
    
    
}
