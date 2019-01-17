//
//  DriverTableViewController.swift
//  Uber Clone Swift4 With Firebase
//
//  Created by Chaman Gurjar on 17/01/19.
//  Copyright © 2019 Chaman Gurjar. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import MapKit

class DriverTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    private static let RIDER_TABLE_NAME = "RideRequest"
    private var rideRequests: [DataSnapshot] = []
    private var locationManager = CLLocationManager()
    private var driverLocation = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationManager()
        
        Database.database().reference().child(DriverTableViewController.RIDER_TABLE_NAME).observe(DataEventType.childAdded) { (snapshot) in
            self.rideRequests.append(snapshot)
            self.tableView.reloadData()
        }
        
        updateLocationDistance()
    }
    
    /* This method will update Driver and Rider distance detaiks
     */
    private func updateLocationDistance() {
        Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { (timer) in
            self.tableView.reloadData()
        }
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = manager.location?.coordinate {
            driverLocation = coordinate
        }
    }
    
    
    @IBAction func logoutUser(_ sender: UIBarButtonItem) {
        try? Auth.auth().signOut()
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - Table view data source
extension DriverTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rideRequests.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rideRequestCell", for: indexPath)
        
        let snapshot = rideRequests[indexPath.row]
        if let rideRequestDetails = snapshot.value as? [String: AnyObject] {
            if let email = rideRequestDetails["email"] as? String {
                
                if let lat = rideRequestDetails["lat"] as? Double, let long = rideRequestDetails["long"] as? Double {
                    let riderLocaiton = CLLocation(latitude: lat, longitude: long)
                    let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
                    let distance = driverCLLocation.distance(from: riderLocaiton) / 1000
                    let roundedDistance = round(distance * 100) / 100 
                    
                    cell.textLabel?.text = "\(email) - \(roundedDistance) KM Away!"
                }
                
                
            }
        }
        return cell
    }
    
}
