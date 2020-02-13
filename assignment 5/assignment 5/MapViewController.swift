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
    var currentPlace: Place?
    
    // MARK: - Initialization Funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Reads in the plist + other stuff (see DataManager for more info)
        DataManager.sharedInstance.loadAnnotationFromPlist()
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 41.8786, longitude: -87.6251), latitudinalMeters: 40000.0, longitudinalMeters: 40000.0)
        mapView.setRegion(region, animated: true)
        
        favoriteBtn.setImage(UIImage(named: "star-empty"), for: .normal)
        favoriteBtn.setImage(UIImage(named: "star-filled"), for: .selected)
        
        // Add all important points from the loaded plist
        addAllPoints()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // Set up the map view
        mapView.showsCompass = false
        mapView.showsPointsOfInterest = false
        
        
    }
    
    // MARK: - Interactions
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let place = view.annotation as? Place {
            locTitle.text = place.name
            locDescrip.text = place.longDescription
            currentPlace = place
            favoriteBtn.isSelected = place.isFave
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let place = annotation as? Place {
            var placeView: PlaceMarkerView
            
            // Format and add annotation views for each Place
            placeView = PlaceMarkerView(annotation: place, reuseIdentifier: "Pin")
            placeView.canShowCallout = true
            placeView.calloutOffset = CGPoint(x: -5, y: 5)
            placeView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            return placeView
        }
        return nil
    }
    
    @IBAction func changeFavoritePlace(_ sender: Any) {
        // Make sure there is actually a Place selected to do something
        if let realPlace = currentPlace {
            realPlace.isFave = !realPlace.isFave
            favoriteBtn.isSelected = realPlace.isFave
            if realPlace.isFave {
                DataManager.sharedInstance.addFavorite(place: realPlace)
            }
            else {
                DataManager.sharedInstance.deleteFavorite(name: realPlace.name!)
            }
        }
    }
    
    func addAllPoints() {
        
        let arr = UserDefaults.standard.object(forKey: "places") as! [[String: Any]]
        var places = [Place]()
        
        // Turn the plist into our Place objects
        for place in arr{
            let coord = CLLocationCoordinate2DMake(place["lat"] as! Double, place["long"] as! Double)
            let annotation = Place(name: (place["name"] as! String), longDescription: (place["description"] as! String), coord: coord)
            places.append(annotation)
            mapView.addAnnotation(annotation)
            
        }
        
        // Try to load in previous favorites
        if DataManager.sharedInstance.favorites.isEmpty, let faves = UserDefaults.standard.object(forKey: "faves") as? [[String : Any]] {
            for fav in faves {
                for place in places {
                    if place.name == fav["name"] as? String {
                        place.isFave = true
                        DataManager.sharedInstance.addFavorite(place: place)
                    }
                }
                
            }
        }
    }
    
    // Make sure the delegate for information passing is set (a bit extra but not sure how else to do this)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "btnPress" {
            let favVC = segue.destination as! FavoritesViewController
            favVC.delegate = self
        }
    }
}

// Allow passing data/action from the Favorites TableView
extension MapViewController: PlacesFavoritesDelegate {
    func favoritePlace(name: String) {
        if let place = DataManager.sharedInstance.getFavorite(name: name) {
            let region = MKCoordinateRegion(center: place.coordinate, latitudinalMeters: 4000.0, longitudinalMeters: 4000.0)
            mapView.setRegion(region, animated: true)
        }
    }
}

// MARK: - MapKit Subclasses

class Place: MKPointAnnotation {
   
    
    var name: String?
    var longDescription: String?
    var isFave = false
    
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
