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
    @IBOutlet weak var locTitle: UILabel!
    @IBOutlet weak var locDescrip: UILabel!
    
    // MARK: - Initialization Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.sharedInstance.loadAnnotationFromPlist()
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.8786, longitude: -87.6251), latitudinalMeters: 40000.0, longitudinalMeters: 40000.0)
        mapView.setRegion(region, animated: true)
        
        favoriteBtn.setImage(UIImage(named: "star-empty"), for: .normal)
        favoriteBtn.setImage(UIImage(named: "star-filled"), for: .selected)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // Set up the map view
        mapView.showsCompass = false
        mapView.showsPointsOfInterest = false
        
        // Add all important points from the loaded plist
        addAllPoints()
    }
    
    // MARK: - Interactions
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let place = view.annotation as? Place {
            locTitle.text = place.name
            locDescrip.text = place.longDescription
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let place = annotation as? Place {
            var placeView: PlaceMarkerView
            
            placeView = PlaceMarkerView(annotation: place, reuseIdentifier: "Pin")
            placeView.canShowCallout = true
            placeView.calloutOffset = CGPoint(x: -5, y: 5)
            placeView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            placeView.markerTintColor = .blue
            
            return placeView
        }
        return nil
    }
    
    @IBAction func addFavoritePlace(_ sender: Any) {
        // TODO actually add the place to favorites
        favoriteBtn.isSelected = !favoriteBtn.isSelected
    }
    
    func addAllPoints() {
        
        let arr = UserDefaults.standard.object(forKey: "places") as! [[String: Any]]
        
        for place in arr{
            let coord = CLLocationCoordinate2DMake(place["lat"] as! Double, place["long"] as! Double)
            let annotation = Place(name: (place["name"] as! String), longDescription: (place["description"] as! String), coord: coord)
            mapView.addAnnotation(annotation)
            
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
            markerTintColor = .red
            glyphImage = UIImage(named: "map-pin")
        }
    }
    
}
