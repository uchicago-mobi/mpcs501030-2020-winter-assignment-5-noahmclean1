//
//  ViewController.swift
//  assignment 5
//
//  Created by Noah McLean on 2/8/20.
//  Copyright © 2020 Noah McLean. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView! {
        didSet { mapView.delegate = self}
    }
    @IBOutlet weak var favoriteBtn: UIButton!
    
    // MARK: - Initialization Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.8786, longitude: -87.6251), latitudinalMeters: 40000.0, longitudinalMeters: 40000.0)
        mapView.setRegion(region, animated: true)
        
        favoriteBtn.setImage(UIImage(named: "star-empty"), for: .normal)
        favoriteBtn.setImage(UIImage(named: "star-filled"), for: .selected)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // Set up the map view
        mapView.showsCompass = false
        mapView.showsPointsOfInterest = false
        
        
        // TODO add import points from plist
        addAllPoints()
    }
    
    @IBAction func addFavoritePlace(_ sender: Any) {
        // TODO actually add the place to favorites
        favoriteBtn.isSelected = !favoriteBtn.isSelected
    }
    
    func addAllPoints() {
        
        var ndict: NSDictionary?
        if let path = Bundle.main.path(forResource: "Data", ofType: "plist") {
            ndict = NSDictionary(contentsOfFile: path)
            
            let places = ndict!["places"] as! [[String:Any]]
            
            for place in places{
                let coord = CLLocationCoordinate2DMake(place["lat"] as! Double, place["long"] as! Double)
                let annotation = Place(name: (place["name"] as! String), longDescription: (place["description"] as! String), coord: coord)
                mapView.addAnnotation(annotation)
            }
        } else {
            print("Failed to load plist data of locations")
        }
        
        
    }
}

// MARK: - MapKit Subclasses

class Place: MKPointAnnotation {
    var name: String?
    var longDescription: String?
    
    init(name: String?, longDescription: String?, coord: CLLocationCoordinate2D) {
        super.init()
        
        self.name = name
        self.longDescription = longDescription
        self.coordinate = coord
    }
}

class PlaceMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            clusteringIdentifier = "Place"
            displayPriority = .defaultLow
            //markerTintColor = .systemRed
            glyphImage = UIImage(named: "map-pin")
        }
    }
    
    
}
