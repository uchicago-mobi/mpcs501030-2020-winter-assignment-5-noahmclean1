//
//  ViewController.swift
//  assignment 5
//
//  Created by Noah McLean on 2/8/20.
//  Copyright © 2020 Noah McLean. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.showsCompass = false
        mapView.showsPointsOfInterest = false
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.8786, longitude: -87.6251), latitudinalMeters: 1000.0, longitudinalMeters: 1000.0)
        mapView.setRegion(region, animated: true)
    }


}

