//
//  RiderViewController.swift
//  Uber Clone Swift4 With Firebase
//
//  Created by Chaman Gurjar on 17/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import FirebaseAuth

class RiderViewController: UIViewController, CLLocationManagerDelegate {
    private static let RIDER_TABLE_NAME = "RideRequest"
    
    @IBOutlet private weak var riderMapView: MKMapView!
    @IBOutlet private weak var callAnUberButton: UIButton!
    
    private var locationManager = CLLocationManager()
    private var userLocation = CLLocationCoordinate2D()
    private var isUberBooked = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        checkWhetherUserHasBookedAnUberAlready()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    private func checkWhetherUserHasBookedAnUberAlready() {
        if let email = Auth.auth().currentUser?.email {
            let dbRefrence: DatabaseReference = Database.database().reference().child(RiderViewController.RIDER_TABLE_NAME)
            dbRefrence.queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (snapshot) in
                self.isUberBooked = true
                self.callAnUberButton.setTitle("  Cancel Uber ", for: .normal)
                dbRefrence.removeAllObservers()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        setRegionAndAnotationOnMap(manager)
    }
    
    private func setRegionAndAnotationOnMap(_ manager: CLLocationManager) {
        if let coordinate = manager.location?.coordinate {
            let center = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            userLocation = center
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
            riderMapView.setRegion(region, animated: true)
            
            addAnotation(center)
        }
    }
    
    private func addAnotation(_ center: CLLocationCoordinate2D) {
        riderMapView.removeAnnotations(riderMapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "You are here buddy!"
        riderMapView.addAnnotation(annotation)
    }
    
    @IBAction func callUber (_ sender: UIButton) {
        if let email = Auth.auth().currentUser?.email {
            if isUberBooked {
                cancelAnUber(email)
            } else {
                bookAnUber(email)
            }
        }
        
    }
    
    private func bookAnUber(_ email: String) {
        let riderDetails: [String: Any] = ["email": email, "lat": userLocation.latitude, "long": userLocation.longitude]
        Database.database().reference().child(RiderViewController.RIDER_TABLE_NAME).childByAutoId().setValue(riderDetails)
        isUberBooked = true
        callAnUberButton.setTitle("  Cancel Uber  ", for: .normal)
    }
    
    private func cancelAnUber(_ email: String) {
        isUberBooked = false
        callAnUberButton.setTitle("  Call An Uber  ", for: .normal)
        
        let dbRefrence: DatabaseReference = Database.database().reference().child(RiderViewController.RIDER_TABLE_NAME)
        dbRefrence.queryOrdered(byChild: "email").queryEqual(toValue: email).observe(.childAdded) { (snapshot) in
            snapshot.ref.removeValue()
            dbRefrence.removeAllObservers()
        }
    }
    
    @IBAction func logoutUser(_ sender: UIBarButtonItem) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
